<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{$mail_subject}</title>
<style>
/* Base resets for email clients */
img{-ms-interpolation-mode:bicubic;border:0;height:auto;outline:none;text-decoration:none;}
table, td{mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;}
p, a, li, td, blockquote{mso-line-height-rule:exactly;}
p, a, li, td, body, table, blockquote{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;}
a[x-apple-data-detectors]{color:inherit !important;text-decoration:none !important;font-size:inherit !important;font-family:inherit !important;font-weight:inherit !important;line-height:inherit !important;}
.ReadMsgBody, .ExternalClass{width:100%;}
.ExternalClass, .ExternalClass *{line-height:100%;}
body{margin:0;padding:0;width:100%!important;height:100%!important;background:#eeeeee;}
#bodyTable{width:100%;height:100%;background-color:#eeeeee;}
.mceText {padding:20px;}
.mceText, .mcnTextContent{font-family:"Helvetica Neue", Helvetica, Arial, Verdana, sans-serif;color:#000;}
.mceText p, .mcnTextContent p{margin-top:10px;margin-bottom:10px;font-size:16px;line-height:1.5;}
.mceText h2{margin:0;font-size:25px;line-height:1.5;font-weight:bold;}
.mceText h3{margin:0;font-size:20px;line-height:1.25;font-weight:bold;}
.mceText a{color:#0f848c;text-decoration:underline;}
.bodyCell{padding:0;width:100%;}
.wrapper{max-width:660px;margin:0 auto;}
.logoCell{text-align:center;background-color:#1faab4;padding:20px 24px;}
.logoText{display:inline-block;color:#fff;font-size:26px;font-weight:600;text-decoration:none;}
.contentCell{background:#ffffff;}
.ctaWrapTop{background:#e4f4e0;border-top-left-radius:30px;border-top-right-radius:30px;padding:10px 12px 0px 12px;}
.ctaWrapMid{background:#e4f4e0;padding:0px 24px 12px;}
.ctaWrapBtn{background:#e4f4e0;padding:8px 24px 20px 24px;text-align:center;}
.footerBand{background:#18676c;padding:32px 24px 50px 24px;color:#ffffff;}
.footerLinks p{margin:0;color:#ffffff;}
.bottomFooter{padding:20px;text-align:center;background:transparent;}
/* Button (non-Outlook) */
.btn{display:inline-block;background:#1faab4;color:#ffffff !important;border-radius:50px;font-family:"Helvetica Neue", Helvetica, Arial, Verdana, sans-serif;
     font-size:16px;font-weight:bold;text-decoration:none;padding:16px 28px;}

/* Mobile */
@media only screen and (max-width:480px){
  .wrapper{max-width:660px !important;}
  .contentCell{padding:20px 16px !important;}
  .ctaWrapTop, .ctaWrapMid, .ctaWrapBtn{padding-left:16px !important;padding-right:16px !important;}
  .mceText p{font-size:16px !important;line-height:1.5 !important;}
  .mceText h2{font-size:25px !important;line-height:1.5 !important;}
  .mceText h3{font-size:20px !important;line-height:1.25 !important;}
}
</style>

<!--[if gte mso 15]>
<xml>
  <o:OfficeDocumentSettings xmlns:o="urn:schemas-microsoft-com:office:office">
    <o:AllowPNG/>
    <o:PixelsPerInch>96</o:PixelsPerInch>
  </o:OfficeDocumentSettings>
</xml>
<![endif]-->
</head>
<body>
<center>
  <table id="bodyTable" role="presentation" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="bodyCell" align="center" valign="top">

        <!-- Header -->
        <table role="presentation" class="wrapper" width="100%" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td class="logoCell">
              <a href="https://{$maindomain}/" target="_blank" style="text-decoration:none;color:#ffffff;font-size:24px; font-weight:bold; white-space:nowrap; display:inline-block; max-width:100%; overflow:hidden;">
                {$logomail}
              </a>
              <!--[if mso]>
                <a href="https://{$maindomain}/" style="text-decoration:none;">
                  <span class="logoText">{$logomail}</span>
                </a>
              <![endif]-->
            </td>
          </tr>
        </table>

        <!-- Body -->
        <table role="presentation" class="wrapper" width="100%" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td class="contentCell">
              <div class="mceText">
                {$hello_message}
                {$mail_body}
              </div>

              <!-- CTA block -->
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-top:16px;">
                <tr>
                  <td class="ctaWrapTop">
                    <div class="mceText" style="text-align:center;">
                      <h2>{$mailphrase1}</h2>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="ctaWrapMid">
                    <div class="mceText" style="text-align:center;">
                      <p>{$mailphrase2}</p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="ctaWrapBtn" align="center">
                    <!--[if mso]>
                      <v:roundrect xmlns:v="urn:schemas-microsoft-com:vml" href="https://{$maindomain}/donate"
                        style="v-text-anchor:middle; width:333px; height:50px;" arcsize="50%" strokecolor="#1faab4" fillcolor="#1faab4">
                        <w:anchorlock/>
                        <center style="color:#ffffff;font-family:'Helvetica Neue', Helvetica, Arial, Verdana, sans-serif;font-size:16px;font-weight:bold;">
                          {$mailphrase3}
                        </center>
                      </v:roundrect>
                    <![endif]-->
                    <!--[if !mso]><!-- -->
                      <a href="https://{$maindomain}/donate" target="_blank" class="btn" rel="noreferrer">{$mailphrase3}</a>
                    <!--<![endif]-->
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>

        <!-- Dark footer band -->
        <table role="presentation" class="wrapper" width="100%" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td class="footerBand">
              <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td width="50%" align="left" style="vertical-align:top;padding-bottom:12px;">
                    <a href="https://{$maindomain}/" target="_blank" style="display:inline-block;">
                      <img src="https://{$maindomain}/projects/most/images/mosttransparent.png" width="141" alt="">
                    </a>
                  </td>
                  <td width="50%" align="left" class="footerLinks" style="vertical-align:middle;">
                    <div class="mceText">
                      <p>{$maillink1}</p>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>

        <!-- Bottom footer -->
        <table role="presentation" class="wrapper" width="100%" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td class="bottomFooter">
              {$mail_statimage}
              {$unsubscribeblock}
            </td>
          </tr>
        </table>

      </td>
    </tr>
  </table>
</center>
</body>
</html>