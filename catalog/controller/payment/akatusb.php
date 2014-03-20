<?php

require_once 'akatus_base.php';

class ControllerPaymentAkatusb extends AkatusPaymentBaseController {

    public function index() {
        global $log;

        $order_id = $this->saveOrder();
        $order = $this->getOrder($order_id);
        
        $descontoPaymentMethod = $this->config->get('akatusb_discount');
        if(!empty($descontoPaymentMethod)) {
            $descontoPaymentMethod = number_format($descontoPaymentMethod, 2, '.', '');
            $order['descontoPaymentMethod'] = number_format($descontoPaymentMethod, 2, '.', '');
        }

        $xml = $this->getXML($order);
        $url = $this->getUrl($payment_method = 'akatusb');

        $this->clearSession();
        
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: text/xml'));
        curl_setopt($ch, CURLOPT_POSTFIELDS, "$xml");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        $response = curl_exec($ch);
        curl_close($ch);

        $akatus = $this->xml2array($response);

        if ($akatus['resposta']['status'] == 'erro') {
            $log->write('URL da requisição: ' . $url);
            $log->write('Erro ao tentar realizar transação. Dados enviados:');
            $log->write($xml);

            $log->write('Dados recebidos da Akatus:');
            $log->write(print_r($akatus, true));

            $this->model_checkout_order->confirm($order_id, Transacao::ID_FAILED, $comment = '', $notify = false);

            $ouput = "<script>window.location = 'index.php?route=information/akatus&tipo=4';</script>";
            $this->response->setOutput($ouput);
            
        } else {
            $comment = "Link para o pagamento do Boleto Bancário: \n<br>";
            $comment .= '<a href="' . $akatus['resposta']['url_retorno'] . '" target="_blank">' . $akatus['resposta']['url_retorno'] . '</a>';

            $this->model_checkout_order->confirm($order_id, $this->config->get('akatusb_padrao'), $comment, $notify = true);
            $this->db->query("INSERT INTO akatus_transacoes (id_pedido, id_akatus) VALUES(". $order_id . ",'" .$akatus['resposta']['transacao'] . "')");

            $ouput = "<script>window.location = 'index.php?route=information/akatus&tipo=5&url_boleto=" . urlencode($akatus['resposta']['url_retorno']) . "';</script>";
            $this->response->setOutput($ouput);            
        }        
    }
}
