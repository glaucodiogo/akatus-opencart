<h2>Endereço de Cobrança</h2>

<?php if ($addresses) { ?>
<input type="radio" name="payment_address" value="existing" id="payment-address-existing" checked="checked" />
<label for="payment-address-existing">Quero utilizar um endereço já cadastrado</label>
<div id="payment-existing">
  <select name="address_id" style="width: 100%; margin-bottom: 15px;" size="5">
    <?php foreach ($addresses as $address) { ?>
    <?php if ($address['address_id'] == $address_id) { ?>
    <option value="<?php echo $address['address_id']; ?>" selected="selected"><?php echo $address['firstname']; ?> <?php echo $address['lastname']; ?>, <?php echo $address['address_1']; ?>, <?php echo $address['city']; ?>, <?php echo $address['zone']; ?>, <?php echo $address['country']; ?></option>
    <?php } else { ?>
    <option value="<?php echo $address['address_id']; ?>"><?php echo $address['firstname']; ?> <?php echo $address['lastname']; ?>, <?php echo $address['address_1']; ?>, <?php echo $address['city']; ?>, <?php echo $address['zone']; ?>, <?php echo $address['country']; ?></option>
    <?php } ?>
    <?php } ?>
  </select>
</div>
<p>
  <input type="radio" name="payment_address" value="new" id="payment-address-new" />
  <label for="payment-address-new">Quero utilizar um novo endereço</label>
</p>
<?php } ?>

<div id="payment-new" style="display: <?php echo ($addresses ? 'none' : 'block'); ?>;">
    <span class="required">*</span> Nome:
    <input type="text" name="firstname" value="" class="akatus-field" />

    <span class="required">*</span> Sobrenome:
    <input type="text" name="lastname" value="" class="akatus-field" />

    <span class="required">*</span> Endereço:
    <input type="text" name="address_1" value="" class="akatus-field" />

    <span class="required">*</span> Bairro:<br />
    <input type="text" name="address_2" value="" class="akatus-field" />
    
    <span class="required">*</span> Cidade:
    <input type="text" name="city" value="" class="akatus-field" />
    
    <span id="shipping-postcode-required" class="required">*</span> CEP:
    <input type="text" name="postcode" value="" class="akatus-field" />

    <span class="required">*</span> País:
    <select name="country_id" class="akatus-field">
        <option value="">--- Selecione ---</option>
        <?php foreach ($countries as $country) { ?>
        <?php if ($country['country_id'] == $country_id) { ?>
        <option value="<?php echo $country['country_id']; ?>" selected="selected"><?php echo $country['name']; ?></option>
        <?php } else { ?>
        <option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
        <?php } ?>
        <?php } ?>
    </select>

    <span class="required">*</span> Estado:
    <select name="zone_id" class="akatus-field">--- Selecione ---</select>
    
    <br />
    <br />
</div>

<script>
    $(function() {
        $('input[name=payment_address]').change(function() {

            switch ($(this).val()) {
                
               case 'existing':
                  $("#payment-new").hide();
                  break;
                  
               case 'new':
                  $("#payment-new").show();
                  break;

               default:
                   break;
            }
        });
    });
</script>