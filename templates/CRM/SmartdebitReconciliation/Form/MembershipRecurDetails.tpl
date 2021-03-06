<h3>{ts}Contact Membership and Contribution Recur{/ts}</h3>
<div class="crm-form-block">
  <table>
		
    <tr>
      <td>
        Smart Debit Details
      </td>
      <td>
			<pre>{$SDMandateArray|@print_r:true}</pre>
      </td>
    </tr>
    <tr>
      <td>
        {$form.reference_number.label} 
      </td>
      <td>
       {$form.reference_number.html}
      </td>
    </tr>
    <tr>
      <td>
        {$form.contact_name.label} 
      </td>
      <td>
       {$form.contact_name.html}
       {$form.cid.html}
      </td>
    </tr>
    <tr>
      <td>
        {$form.membership_record.label} 
      </td>
      <td>
       {$form.membership_record.html}<br />
       <sub>( Membership Type / Membership Status / Start Date / End Date)</sub>
      </td>
    </tr>
    <tr>
      <td>
        {$form.contribution_recur_record.label} 
      </td>
      <td>
       {$form.contribution_recur_record.html}<br />
       <sub>( Payment Processor / Contribution Status / Amount)</sub>
      </td>
    </tr>

  </table>
  
  <div class="crm-submit-buttons">
     {include file="CRM/common/formButtons.tpl" location="bottom"}
  </div>
</div>
  <style>
    .crm-container select {
      width:500px;
    }
  </style>
  <script type="text/javascript">
    {literal}
      
      var contactUrl = {/literal}"{crmURL p='civicrm/ajax/rest' q='className=CRM_Contact_Page_AJAX&fnName=getContactList&json=1&context=navigation' h=0 }"{literal};
      var getTemplateContentUrl = {/literal}"{crmURL p='civicrm/ajax/rest' h=0 q='className=CRM_SmartdebitReconciliation_Page_AJAX&fnName=getMembershipByContactID&json=1'}"{literal}  
      cj( '#contact_name' ).autocomplete( contactUrl, {
          width: 200,
          selectFirst: false,
          minChars:1,
          matchContains: true,
          delay: 400
      }).result(function(event, data, formatted) {
          var cid = data[1];
          var name = data[0].split('::');
          cj('input[name=cid]').val(cid);
          cj('#contact_name').val(name[0]);
          cj('#membership_record').parents('tr').show();
          cj('#contribution_recur_record').parents('tr').show();
          cj('.crm-submit-buttons').show();
          cj.ajax({
              url : getTemplateContentUrl,
              type: "POST",
              data: {selectedContact: cid},
              async: false,
              datatype:"json",
              success: function(data, status){
                cj('#membership_record').find('option').remove();
                cj('#contribution_recur_record').find('option').remove();
                var options = cj.parseJSON(data);
                cj.each(options, function(key, value) {
                  if(key == "membership"){
                  var opMem = value;
                  cj.each(opMem, function(memID, text) {
                    cj('#membership_record').append(cj('<option>', { 
                      value: memID,
                      text : text 
                     }));
                  });
                  }
                 if(key == "cRecur"){
                  var opRecur = value;
                  cj.each(opRecur, function(crID, Recurtext) {
                    cj('#contribution_recur_record').append(cj('<option>', { 
                      value: crID,
                      text : Recurtext 
                     }));
                  });
                  }
                });
              }
           });
      });    
      cj(document).ready(function(){
        cj('#membership_record').parents('tr').hide();
        cj('#contribution_recur_record').parents('tr').hide();
        cj('.crm-submit-buttons').hide();
      });
     {/literal}
  </script>