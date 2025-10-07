<!DOCTYPE html>
<html lang="{$lng_html}" prefix="og: http://ogp.me/ns#">
<head>
<title>{$meta_title}</title>
<meta charset="utf-8">
<meta name="description" content="{$meta_description}"/>
{$meta_robots}
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0"/>
<base href="{$base_href}">
{$canonical}
{$schemaorg}
{$linkicons}
<!-- Bootstrap core CSS -->
<link href="/css/bootstrap.css" rel="stylesheet">
<link href="/css/jquery.toast.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="/css/main.css" rel="stylesheet">{$projectcss}

<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
<script src="/js/jquery-2.1.3.min.js"></script>  
<script src="/js/bootstrap.min.js"></script>
<script src="/js/jquery.toast.min.js"></script>
<script src="/js/bootstrap-editable.min.js"></script>
<script src="/js/bootstrap-tagsinput.js"></script>
<script src="/js/bootstrap-datetimepicker.js"></script>
{$datetimepicker_lng_js}
<script src='/js/tinymce/tinymce.min.js'></script>
<script src='/js/tinymce/jquery.tinymce.min.js'></script>
<script src="/js/bootpopup.js"></script>
<link rel="stylesheet" href="/js/tinymce/plugins/codesample/prism.css">
<script src="/js/tinymce/plugins/codesample/prism.js"></script>
<link href="/css/bootstrap-editable.css" rel="stylesheet" type="text/css">
<link href="/css/bootstrap-tagsinput.css" rel="stylesheet" type="text/css">
<link href="/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
<style>
.label-info {
    background-color: #9e9e9e;
}
.label {
    border-radius: 0.25em;
    color: #fff;
    display: inline;
    font-size: 90%;
    font-weight: bold;
    line-height: 1;
    padding: 0.2em 0.6em 0.3em;
    text-align: center;
    vertical-align: baseline;
    white-space: nowrap;
}
</style>
<script>
function js_translate(str) {
	if (str == '{$phraseclose}') { str = '{$btn_close}'; } if (str == 'Close') { str = '{$btn_close}'; }
	if (str == '{$phraseok}') { str = '{$btn_ok}'; }
	if (str == '{$phrasecancel}') { str = '{$btn_cancel}'; }
	if (str == '{$phraseyes}') { str = '{$btn_yes}'; }
	if (str == '{$phraseno}') { str = '{$btn_no}'; }
	return str;
}
function geo_success(position)
{
	$.post( "./api/googlemaps.php", { latitude: position.coords.latitude, longitude: position.coords.longitude })
	  .done(function( data ) {
		if (data != '')
		{
			setgeodata(data,position.coords.latitude,position.coords.longitude);
		}
		else
		{
			setgeodata('{$user_geoip_location}','','');
		}		
	});
}
function geo_error(error)
{
	setgeodata('{$user_geoip_location}','','');
}
function setgeodata(postlocation,latitude,longitude)
{
		document.getElementById('postlocation').value = postlocation;
		document.getElementById('latitude').value = latitude;
		document.getElementById('longitude').value = longitude;
}
function locationdetect(act) {
	if (act)
	{
		if ('geolocation' in navigator)
		{
			var geo_options = {
				enableHighAccuracy : true, 
				maximumAge : 45000, 
				timeout  : 30000
			};

			navigator.geolocation.getCurrentPosition(geo_success, geo_error, geo_options);
		}
		else
		{
			setgeodata('{$user_geoip_location}','','');
		}
	}
	else
	{
		setgeodata('','','');
	}
}
function choisemood(eid) {
	if (eid == 0) 
	{
		if (document.getElementById('moods').style.display == 'none')
		{
			document.getElementById('moods').style.display = 'block';
		}
		else
		{
			document.getElementById('moods').style.display = 'none';
		}
	}
	if (eid > 0) 
	{
		document.getElementById('emotioninner').innerHTML = '<img src="images/emotions/' + eid + '.png" border="0" width="20" height="20" align="left"  style="margin-top: 4px;">';
		document.getElementById('inputemotion').innerHTML = '<input type="text" name="emotiontext" id="emotiontext" value="' + document.getElementById('emotiontext'+eid).innerHTML + '" style="margin-left: 5px;"> <button type="button" class="btn btn-default btn-xs" aria-label="Left Align" onclick="choisemood(-1)" style="margin-right: 30px;"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button>';
		document.getElementById('inputemotion').style.display = 'block';
		document.getElementById('emotionid').value = eid;
		document.getElementById('moods').style.display = 'none';
	}
	if (eid < 0) 
	{
		document.getElementById('emotioninner').innerHTML = 'Choose your mood';
		document.getElementById('inputemotion').innerHTML = '<input type="hidden" name="emotiontext" id="emotiontext" value="">';
		document.getElementById('inputemotion').style.display = 'none';
		document.getElementById('emotionid').value = 0;
		document.getElementById('moods').style.display = 'none';
	}
}
function getcategory() {
	document.getElementById('categorylist').innerHTML = '';
	$.ajax({
		url: './getcategory.php',
		type: 'POST',
		data: {postid: {$postid}, community: '{$community}'},
		async: true,
		success: function(response) {
			$('#categorylist').append(response);
		},
		error: function(response) {
			bootpopup.alert("Sorry, there was some error with the request. Please refresh the page.","Error");
		}
	});
}
function editpicture(filename,filepath,description) {
	insmode = 0;
	document.getElementById('todelete').checked = false;
	document.getElementById('photo_b64').value = '';
	document.getElementById('filename').value = filename;
	document.getElementById('description').value = description;
	document.getElementById('editphoto').src = filepath;
	document.getElementById('saveimgbutton').disabled = false;
	document.getElementById('cancelimgbutton').disabled = false;
	document.getElementById('selectfile').style.display = 'none';
	document.getElementById('deletediv').style.display = 'inline-block';
	document.getElementById('saveimgbutton').innerHTML = 'Save changes';
	$("#newpicture").appendTo("body").modal('show');	
}
function addpicture(fileid) {
	insmode = fileid;
	document.getElementById('todelete').checked = false;
	document.getElementById('editphoto').src = './images/no-image.png';
	document.getElementById('filename').value = '';
	document.getElementById('photo_b64').value = '';
	document.getElementById('PhotoFile').value = '';
	document.getElementById('description').value = '';
	document.getElementById('saveimgbutton').disabled = false;
	document.getElementById('cancelimgbutton').disabled = false;
	document.getElementById('selectfile').style.display = 'inline-block';
	document.getElementById('deletediv').style.display = 'none';
	if (insmode == -1)
	{
		document.getElementById('saveimgbutton').innerHTML = 'Insert image';
	}
	else
	{
		document.getElementById('saveimgbutton').innerHTML = 'Save changes';
	}
	$("#newpicture").appendTo("body").modal('show');
}
function insimage(webpath,filename) {
	$('#editor').html( tinymce.get('editor').getContent() );
	$('#result').html($('#editor').val() + '<figure><a class="js-smartPhoto" href="'+webpath+'" target="_blank" rel="noopener"><img style="width:100%;" src="'+webpath+'" /></a><figcaption class="photo-figure">Photo from open sources</figcaption></figure><p></p>');
	tinyMCE.activeEditor.setContent($("#result").html());
	tinymce.activeEditor.save();
	$.post( "./loadpictures.php", { photo_b64: '', filename: filename, description: 'updatedate', postid: '{$postid}' })
	  .done(function( data ) {
	});
	goposttab();
}
function saveimage() {
	var photo_b64 = document.getElementById('photo_b64').value;
	var filename = document.getElementById('filename').value;
	var description = document.getElementById('description').value;
	if (document.getElementById('todelete').checked) {
		$('#editor').html( tinymce.get('editor').getContent() );
		$('#result').html($('#editor').val());
		var postbody = document.getElementById('result').innerHTML;
		if (postbody.indexOf(filename) + 1)
		{
			$("#newpicture").appendTo("body").modal('hide');	
			bootpopup.alert('This image is used in the publication!','Error');
			return;
		}
		var description = 'delete';
		insmode = 0;
		if (filename == thumbnailfilename && thumbnailfilename != '')
		{
			thumbnailfilename = '';
			thumbnailmd5file = '';
			document.getElementById('thumbnailfilename').innerHTML = thumbnailfilename;
		}
	}
	else if (photo_b64 == '' && filename == '')
	{
		return;
	}
	$('#p_prldr').show();
	$.post( "./loadpictures.php", { photo_b64: photo_b64, filename: filename, description: description, postid: '{$postid}' })
	  .done(function( data ) {
		$('#p_prldr').delay(100).fadeOut('slow');
		if(!(data.indexOf('.jpg') + 1) && data != 'OK')
		{
			bootpopup.alert(data,'Error');
		}
		else
		{
			$("#newpicture").modal('hide');
			document.getElementById('data-container').innerHTML = '';
			if (insmode == -1)
			{
				tinyMCE.activeEditor.insertContent('<figure><a class="js-smartPhoto" href="'+data+'" target="_blank" rel="noopener"><img style="width:100%;" src="'+data+'" /></a><figcaption class="photo-figure">'+description+'</figcaption></figure><p></p>');
				if (thumbnailmd5file == '')
				{
					thumbnailfilename = data.substring(data.lastIndexOf('/')+1,data.length);
					var reg=/([a-z0-9\-\._]+)(\.([a-z]{1,4}))$/i; 
					thumbnailmd5file=reg.exec(thumbnailfilename)[1];
					document.getElementById('thumbnailfilename').innerHTML = thumbnailfilename;
				}
			}
			dataloading.load(1);
		}
	});
}
function checkcat(catid) {
	var postcategories = document.getElementById('postcategories').value;	
	if (document.getElementById('checkcat'+catid).checked)
	{
		var postcategories = postcategories + '|' + catid + '|';
	}
	else
	{
		var postcategories = postcategories.replace('|' + catid + '|', '');
	}
	document.getElementById('postcategories').value = postcategories;
}
function deletepost() {
	qwst = '';
	if ('{$blog_post[addays]}' != '' && '{$blog_post[addays]}' != '0')
	{
		if ({$blog_post[user_id]} == {$user_id})
		{
			qwst = 'This is an advertising post. If you delete it, the funds for its publication will NOT be returned!';
		}
		else
		{
			qwst = 'This is an advertising post. If you delete it, the amount of previously received income will be canceled.';
		}
	}
	qwst = qwst +' Are you sure you want to remove this post?';
	bootpopup.confirm(qwst, 'The removal of the post', function(ans) { if (ans) {
	$('#p_prldr').show();
	$.post( "./removepost.php", { checkID: {$startruntime}, postid: '{$postid}', community: '{$community}' })
	  .done(function( data ) {
		if (data != 'OK')
		{
			$('#p_prldr').delay(100).fadeOut('slow');
			bootpopup.alert(data,'Error');
		}
		else
		{
			location.href = '{$addpath}/';
		}
	});		
	}});
}
function savepost() {
	tinymce.activeEditor.save();
	adperiod = '';
	var emotionid = document.getElementById('emotionid').value;
	var emotiontext = document.getElementById('emotiontext').value;
	var postlocation = document.getElementById('postlocation').value;
	var latitude = document.getElementById('latitude').value;
	var longitude = document.getElementById('longitude').value;
	var posttitle = document.getElementById('posttitle').value;
	var author_id = document.getElementById('author_id').value;
	var subhead = document.getElementById('subhead').value;

	var RT_EN = '';
	if (document.getElementById('RT_EN').checked) { var RT_EN = '1'; }
	
	var RT_FR = '';
	if (document.getElementById('RT_FR').checked) { var RT_FR = '1'; }
	
	var RT_DE = '';
	if (document.getElementById('RT_DE').checked) { var RT_DE = '1'; }
	
	var RT_ES = '';
	if (document.getElementById('RT_ES').checked) { var RT_ES = '1'; }

	var posttitleEN = document.getElementById('posttitleEN').value;
	var subheadEN = document.getElementById('subheadEN').value;
	var postbodyEN = document.getElementById('postbodyEN').value;
	var descriptionEN = document.getElementById('descriptionEN').value;

	var posttitleFR = document.getElementById('posttitleFR').value;
	var subheadFR = document.getElementById('subheadFR').value;
	var postbodyFR = document.getElementById('postbodyFR').value;
	var descriptionFR = document.getElementById('descriptionFR').value;

	var posttitleDE = document.getElementById('posttitleDE').value;
	var subheadDE = document.getElementById('subheadDE').value;
	var postbodyDE = document.getElementById('postbodyDE').value;
	var descriptionDE = document.getElementById('descriptionDE').value;

	var posttitleES = document.getElementById('posttitleES').value;
	var subheadES = document.getElementById('subheadES').value;
	var postbodyES = document.getElementById('postbodyES').value;
	var descriptionES = document.getElementById('descriptionES').value;

	if ((author_id == 0 || author_id == '') && {$config[is_media]} == 1)
	{
		bootpopup.alert('You must select an author!','Please pay attention!');
		return;
	}
	if (document.location.href.indexOf("?ad",0)>0 && adperiod == '')
	{
		bootpopup.alert('You did not choose the period of placement of the advertising post!','Please pay attention!');
		return;
	}
	if (posttitle.length < 3)
	{
		bootpopup.alert('Specify the title of this post!','Please pay attention!');
		return;
	}

	$('#editor').html( tinymce.get('editor').getContent() );
	var postbody = $('#editor').val();

	if (postbody.length < 30)
	{
		bootpopup.alert('The minimum length of the post - 30 characters.','Please pay attention!');
		return;
	}
	if (emotiontext.length > 30)
	{
		bootpopup.alert('Description of emotion should not be more than 30 characters!','Please pay attention!');
		return;
	}
	var showcomments = '0';
	if (document.getElementById('showcomments').checked) { var showcomments = '1'; }	
	var posttype = '0';
	if (document.getElementById('posttype0').checked) { var posttype = '0'; }
	if (document.getElementById('posttype1').checked) { var posttype = '1'; }
	var accessmode = '0';
	if (document.getElementById('accessmode0').checked) { var accessmode = '0'; }
	if (document.getElementById('accessmode1').checked) { var accessmode = '1'; }
	var donates = '1';
	if (document.getElementById('donates0').checked) { var donates = '0'; }
	var commentsmode = '0';
	if (document.getElementById('commentsmode0').checked) { var commentsmode = '0'; }
	if (document.getElementById('commentsmode1').checked) { var commentsmode = '1'; }
	if (document.getElementById('commentsmode2').checked) { var commentsmode = '2'; }
	var nolng = '0';
	if (document.getElementById('nolng').checked) { var nolng = '1'; }
	var posttags = document.getElementById('posttags').value;
	if (posttags.length > 500)
	{
		bootpopup.alert('Too many tags!','Please pay attention!');
		return;
	}
	var postdescription = document.getElementById('postdescription').value;
	if (postdescription.length > 320)
	{
		bootpopup.alert('Description should not be more than 320 characters!','Please pay attention!');
		return;
	}
	var posttime = document.getElementById('posttime').value;
	var attached = '0';
	if (document.getElementById('attached').checked) { var attached = '1'; }
	var postcategories = document.getElementById('postcategories').value;
	var pricecurr = document.getElementById('usercurr').value;
	var price = document.getElementById('price').value;
	if ('{$community_type}' == '1' && price <= 0)
	{
		bootpopup.alert('You must specify the price of the goods!','Please pay attention!');
		return;
	}	
	$('#p_prldr').show();
	$.post( "./savepost.php", { author_id: author_id, subhead: subhead, emotionid: emotionid, emotiontext: emotiontext, postlocation: postlocation, latitude: latitude, longitude: longitude, posttitle: posttitle, postbody: postbody, posttype: posttype, accessmode: accessmode, donates: donates, commentsmode: commentsmode, showcomments: showcomments, posttags: posttags, posttime: posttime, attached: attached, price: price, pricecurr: pricecurr, postcategories: postcategories, thumbnailfilename: thumbnailfilename, postdescription: postdescription, adperiod: adperiod, nolng: nolng, checkID: {$startruntime}, postid: '{$postid}', userutc: '{$user_utc}', community: '{$community}', posttitleEN: posttitleEN, subheadEN: subheadEN, postbodyEN: postbodyEN, descriptionEN: descriptionEN, posttitleFR: posttitleFR, subheadFR: subheadFR, postbodyFR: postbodyFR, descriptionFR: descriptionFR, posttitleDE: posttitleDE, subheadDE: subheadDE, postbodyDE: postbodyDE, descriptionDE: descriptionDE, posttitleES: posttitleES, subheadES: subheadES, postbodyES: postbodyES, descriptionES: descriptionES, RT_EN: RT_EN, RT_FR: RT_FR, RT_DE: RT_DE, RT_ES: RT_ES })
	  .done(function( data ) {
		if (data > 0)
		{
			tinymce.remove();
			$('#editor').hide();
			location.href = '{$addpath}/' + data;
		}
		else
		{
			$('#p_prldr').delay(100).fadeOut('slow');
			if(data.indexOf('posthash') + 1)
			{
				data = 'The text of the post must be unique!';
			}
			bootpopup.alert(data,'Please pay attention!');
		}
	});
}
function resizeFile(file, editphoto, b64field) {
	$('#p_prldr').show();
	var reader = new FileReader();
    reader.onloadend = function () {
        var tempImg = new Image();
        tempImg.src = reader.result;
        tempImg.onload = function () {
            var tempW = tempImg.width;
            var tempH = tempImg.height;
            imgcrop(this, tempW, tempH, 1920, 12790, b64field);
            $(editphoto).attr('src', $(b64field).val());
			$('#p_prldr').delay(100).fadeOut('slow');
       }
    }
    reader.readAsDataURL(file);
}
function imgcrop(image, tempW, tempH, maxW, maxH, elem) {
	var sourceX = 0;
	var sourceY = 0;
	var destWidth = tempW;
	var destHeight = tempH;
	if (tempW > maxW)
	{
		var destWidth = maxW;
		var destHeight = destHeight * (maxW/tempW);
	}
	if (destHeight > maxH)
	{
		var destWidth = tempW;
		var destHeight = tempH;
		var destHeight = maxH;
		var destWidth = destWidth * (maxH/tempH);
	}
	var destX = 0;
	var destY = 0;

	var canvas = document.createElement('canvas');
	canvas.width = destWidth;
	canvas.height = destHeight;

	var ctx = canvas.getContext("2d");
	ctx.fillStyle = "#FFFFFF";
    ctx.fillRect(0, 0, destWidth, destHeight);
	ctx.drawImage(image, sourceX, sourceY, tempW, tempH, destX, destY, destWidth, destHeight);
	var dataURL = canvas.toDataURL("image/jpeg");
	$(elem).val(dataURL);
}
function showeditphoto() {
	var image = $("#PhotoFile");
	if (image[0].files && image[0].files[0]) {
		resizeFile(image[0].files[0], $('#editphoto'), $('#photo_b64'))
	}
}
function gopictab() {
	$("#posttab").removeClass("active");
	$("#Mypost").removeClass("active");
	$("#MyENtab").removeClass("active");
	$("#MyFRtab").removeClass("active");
	$("#MyDEtab").removeClass("active");
	$("#MyEStab").removeClass("active");
	$("#pictab").addClass("active");
	$("#Mypictures").addClass("active");
	window.scrollTo(0, 0);
}
function goposttab() {
	$("#pictab").removeClass("active");
	$("#Mypictures").removeClass("active");
	$("#MyENtab").removeClass("active");
	$("#MyFRtab").removeClass("active");
	$("#MyDEtab").removeClass("active");
	$("#MyEStab").removeClass("active");
	$("#posttab").addClass("active");
	$("#Mypost").addClass("active");
	window.scrollTo(0, 0);
}
function opengraph(thiscontent) {
	if (getopengraph == 0)
	{
		getopengraph = 1;
		$.ajax({
			url: './opengraph.php',
			type: 'POST',
			data: { thiscontent: thiscontent, url: '' },
			async: false,
			success: function(response) {
				response = $.parseJSON(response);
				if (response[0] == 'OK' && response[1] != '')
				{	
					tinyMCE.activeEditor.setContent(thiscontent+response[1]+'<p>&nbsp;</p>');
					tinymce.activeEditor.save();
					titletext = document.getElementById('posttitle').value;
					if (titletext == '' && response[2] != '')
					{
						document.getElementById('posttitle').value = response[2];
					}
				}
				getopengraph = 0;
			}
		});
	}
}
function selectthumbnail(md5file,filename) {
	if (thumbnailmd5file != '')
	{
		thn = document.getElementById('thn'+thumbnailmd5file);
		img = document.getElementById('img'+thumbnailmd5file);
		if ($('#thn'+thumbnailmd5file).length > 0)
		{
			img.style.backgroundColor = "#eaeaea";
			thn.checked = false;
		}
	}
	if (md5file != '')
	{
		thn = document.getElementById('thn'+md5file);
		img = document.getElementById('img'+md5file);
		thumbnailfilename = document.getElementById('thumbnailfilename').innerHTML;
		if (thn.checked == true)
		{
			img.style.backgroundColor = "#b6e1fc";
			thumbnailfilename = filename;
			thumbnailmd5file = md5file;
			document.getElementById('thumbnailfilename').innerHTML = thumbnailfilename;
		}
		else
		{
			img.style.backgroundColor = "#eaeaea";
			thumbnailfilename = '';
			thumbnailmd5file = '';
			document.getElementById('thumbnailfilename').innerHTML = thumbnailfilename;
		}
	}
	else
	{
		thumbnailfilename = '';
		thumbnailmd5file = '';
		document.getElementById('thumbnailfilename').innerHTML = thumbnailfilename;
	}
}
function uploadclick() {
	if (canupload)
	{
		$('#UserFile').prop('disabled',false);
		$('#UserFile').click();
	}
}
function loadfile() {
	var files = document.getElementById('UserFile').files;
	if (files.length == 0)
	{
		$('#UserFile').prop('disabled',true);
		return;
	}
	var fileToLoad = files[0];
	var fileReader = new FileReader();
	var fileaccess = 1;
	var filename = files[0].name;
	var filedesc = 'Attach ' + filename;
	$("#uploadingwin").modal('show');
	$('#progressbar').show();
	$('#filechecking').hide();
	$('#progressperc').html('');
	$('#progressline').attr('aria-valuenow', '0').css('width', '0%');
	fileReader.onload = function(fileLoadedEvent) 
	{
		filebase64 = fileLoadedEvent.target.result;
		$.ajax({
		  type: 'POST',
		  url: "./uploadfile.php",
		  data: { filename: filename, filebase64: filebase64, fileaccess: fileaccess, filedesc: filedesc, md5f: '', notuniq: 1 },
		  xhr: function() {
				var xhr = $.ajaxSettings.xhr();
				xhr.upload.onprogress = function(e) {
					percentComplete = Math.floor(e.loaded / e.total *100);
					$('#progressperc').html(' '+percentComplete+'%');
					if (percentComplete >= 100)
					{
						$('#progressbar').hide();
						$('#filechecking').show();
					}
					else
					{
						$('#progressline').attr('aria-valuenow', percentComplete).css('width', percentComplete+'%');
					}
				};
				return xhr;
		  },
		  success: function(data){
			data = $.parseJSON(data);
			$("#uploadingwin").modal('hide');
			if (data[0] != 'OK')
			{
				bootpopup.alert(data[0],'Error');
			}
			else
			{
				var thiscontent = tinymce.get('editor').getContent();
				tinyMCE.activeEditor.setContent(thiscontent + '<p><strong>Download:</strong> <a href="/file/' + data[1] + '?oid=u{$user_id}">' + filename + '</a> (' + data[3] + ')</p>');
				tinymce.activeEditor.save();
			}
			$('#UserFile').prop('disabled',true);
		  },
		  error: function(jqXHR, exception){
			$("#uploadingwin").modal('hide');
			var msg = '';
			if (jqXHR.status === 0) {
				msg = 'Not connect. Verify Network.';
			} else if (jqXHR.status == 404) {
				msg = 'Requested page not found. [404]';
			} else if (jqXHR.status == 413) {
				msg = 'File is too big!';
			} else if (jqXHR.status == 500) {
				msg = 'Internal Server Error [500].';
			} else if (exception === 'parsererror') {
				msg = 'Requested JSON parse failed.';
			} else if (exception === 'timeout') {
				msg = 'Time out error.';
			} else if (exception === 'abort') {
				msg = 'Ajax request aborted.';
			} else {
				msg = jqXHR.responseText;
			}
			bootpopup.alert(msg,'Error');
		  }
		});
	};
	fileReader.onerror = function (error) {
		$("#uploadingwin").modal('hide');
		$('#UserFile').prop('disabled',true);
		alert(error);
	};
	fileReader.readAsDataURL(fileToLoad);
}
function tagsmaster() {
	$('#tagsbtn').hide();
	$('#tagsloading').show();
	var posttitle = document.getElementById('posttitle').value;
	$('#editor').html( tinymce.get('editor').getContent() );
	var postbody = $('#editor').val();
	var posttext = '<h1>'+posttitle+'</h1>'+postbody;
	$.ajax({
	  type: 'POST',
	  url: "./tagsmaster.php",
	  data: { posttext: posttext },
	  success: function(data){
		data = $.parseJSON(data);
		if (data[0] == 'OK')
		{
			$('#posttags').tagsinput('removeAll');
			data[1].split(',').forEach(function(tag) {
				$('#posttags').tagsinput('add', tag.trim());
			});
			$('#tagsloading').hide();
			$('#tagsbtn').show();
			$('#posttags').tagsinput({
			 maxTags: 25
			});
		}
	  },
	  error: function(jqXHR, exception){
		$('#tagsloading').hide();
		$('#tagsbtn').show();
		var msg = '';
		if (jqXHR.status === 0) {
			msg = 'Not connect. Verify Network.';
		} else if (jqXHR.status == 404) {
			msg = 'Requested page not found. [404]';
		} else if (jqXHR.status == 413) {
			msg = 'File is too big!';
		} else if (jqXHR.status == 500) {
			msg = 'Internal Server Error [500].';
		} else if (exception === 'parsererror') {
			msg = 'Requested JSON parse failed.';
		} else if (exception === 'timeout') {
			msg = 'Time out error.';
		} else if (exception === 'abort') {
			msg = 'Ajax request aborted.';
		} else {
			msg = jqXHR.responseText;
		}
		bootpopup.alert(msg,'Error');
	  }
	});
}
function decodeUnicodeEscapes(str) {
  return str.replace(/\\u([\dA-Fa-f]{4})/g, function (match, grp) {
    return String.fromCharCode(parseInt(grp, 16));
  });
}
$(document).ready(function () {
	$("#UserFile").change(function(){
		loadfile();
	});
	if ({$postid})
	{
		if ({$blog_post[emotion]})
		{
			document.getElementById('emotionid').value = '{$blog_post[emotion]}';
			choisemood({$blog_post[emotion]});
			document.getElementById('emotiontext').value = '{$blog_post[emotion_descr]}';
		}
		document.getElementById('postlocation').value = '{$blog_post[location]}';
		document.getElementById('latitude').value = '{$blog_post[latitude]}';
		document.getElementById('longitude').value = '{$blog_post[longitude]}';
		if ({$blog_post[showcomments]}) { document.getElementById('showcomments').checked = true; }
		if ({$blog_post[attached]}) { document.getElementById('attached').checked = true; }
		if ({$blog_post[notranslate]}) { document.getElementById('nolng').checked = true; }
		document.getElementById('posttype{$blog_post[posttype]}').checked = true;
		document.getElementById('accessmode{$blog_post[accessmode]}').checked = true;
		document.getElementById('donates{$blog_post[donates]}').checked = true;
		document.getElementById('commentsmode{$blog_post[commentsmode]}').checked = true;

		pos = document.getElementById('editor').innerHTML.indexOf("&lt;script");
		while ( pos != -1 ) {
			$("#editor").html(function(index, text) {
				return text.replace("&lt;script", "&lt;scriрt");
			});
			pos = document.getElementById('editor').innerHTML.indexOf("&lt;script",pos+1);
		}
		
		pos = document.getElementById('editor').innerHTML.indexOf("script&gt;");
		while ( pos != -1 ) {
			$("#editor").html(function(index, text) {
				return text.replace("script&gt;", "scriрt&gt;");
			});
			pos = document.getElementById('editor').innerHTML.indexOf("script&gt;",pos+1);
		}

		pos = document.getElementById('editor').innerHTML.indexOf("/scr");
		while ( pos != -1 ) {
			$("#editor").html(function(index, text) {
				return text.replace("/scr", "&frasl;scr");
			});
			pos = document.getElementById('editor').innerHTML.indexOf("/scr",pos+1);
		}

		thumbnailfilename = '{$blog_post[thumbnail]}';
		thumbnailmd5file = '{$blog_post[thumbnailmd5]}';
		document.getElementById('thumbnailfilename').innerHTML = thumbnailfilename;
	}
	else
	{
		document.getElementById('posttype0').checked = true;
		document.getElementById('accessmode1').checked = true;
		document.getElementById('donates1').checked = true;
		document.getElementById('commentsmode0').checked = true;
		document.getElementById('showcomments').checked = true;
		$('.deletebutton').hide();
		thumbnailfilename = '';
		thumbnailmd5file = '';
	}
	wheight = $(window).height() * 0.55;
	getopengraph = 0;
	activeEditor = tinymce.init({
		selector: '#editor',
		skin: "custom",
		toolbar: 'restoredraft | undo redo | searchreplace | bold italic forecolor backcolor tinymceEmoji | link myimage media | alignleft aligncenter alignright | blockquote | bullist numlist outdent indent | table | ltr rtl | code codesample',
		plugins: "autosave advlist autolink lists link imagetools code codesample media visualblocks preview visualblocks visualchars tinymceEmoji directionality wordcount paste colorpicker textcolor table",
		emoji_add_space: true,
		emoji_show_subgroups: false,
		emoji_show_tab_icons: true,
		branding: false,
		relative_urls: false,
		remove_script_host: true,
		height: wheight,
		image_advtab: true,
		{$tinymcelng}
		codesample_languages: [
			{text: 'HTML/XML', value: 'markup'},
			{text: 'JavaScript', value: 'javascript'},
			{text: 'CSS', value: 'css'},
			{text: 'PHP', value: 'php'}
		],
		setup: function (editor) {
			editor.addButton('myimage', {
			  text: false,
			  icon: 'image',
			  tooltip: "Upload image",
			  onclick: function () {
				addpicture(-1);
			  }
			});
			editor.on('change', function(e) {
				thiscontent = editor.getContent();
				if (false && thiscontent.indexOf('href=') + 1 && thiscontent.indexOf('sharedlink') + 1 == 0)
				{
					opengraph(thiscontent);
				}
			});
		}
	});
	if ('{$community_type}' != '1')
	{
		document.getElementById('pricediv').style.display = 'none';
	}
	else
	{
		document.getElementById('posttypediv').style.display = 'none';
	}
	getcategory();
	canupload = true;
	if ({$blog_info[mainproject]} == 1)
	{
		$('#emotiondiv').hide();
		$('#postlocationdiv').hide();
		if ({$config[is_media]} == 1)
		{
			$('#authordiv').show();
			$('#subheaddiv').show();
			$('#entab').show();
			$('#frtab').show();
			$('#detab').show();
			$('#estab').show();
		}
	}
});
</script>
</head>
<body data-no-turbolink>
{$header}
<div class="container">
<h2 style="margin-top: 0;">{$blog_post[postheader]}</h2>
<div class="tabs">
<ul class="nav nav-tabs smile-tabs">
<li id="posttab" class="active"><a href="#Mypost" data-toggle="tab">My post</a></li>
<li id="pictab"><a href="#Mypictures" data-toggle="tab">My pictures</a></li>
<li id="entab" style="display:none"><a href="#MyENtab" data-toggle="tab"><span class="nottranslate">EN</span></a></li>
<li id="frtab" style="display:none"><a href="#MyFRtab" data-toggle="tab"><span class="nottranslate">FR</span></a></li>
<li id="detab" style="display:none"><a href="#MyDEtab" data-toggle="tab"><span class="nottranslate">DE</span></a></li>
<li id="estab" style="display:none"><a href="#MyEStab" data-toggle="tab"><span class="nottranslate">ES</span></a></li>
</ul>                 
<div class="tab-content">
<div class="tab-pane" id="MyENtab">
<label><input type="checkbox" id="RT_EN"> Request a translation</label><br>
<small>If you enable this checkbox, the request for a new translation will be completed within a few minutes after saving this article in the "Published" mode.</small>
<h4>Title:</h4>
<input id="posttitleEN" type="text" value="{$blog_post[titleEN]}" style="width:100%;padding:5px;">
<h4>Introduction:</h4>
<textarea id="subheadEN" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[subheadEN]}</textarea>
<h4>HTML body of the article:</h4>
<textarea id="postbodyEN" class="form-control" style="margin-top:10px;width:100%;height: 80vh;resize:vertical;padding:5px;">{$blog_post[htmlEN]}</textarea>
<h4>OG-Description:</h4>
<textarea id="descriptionEN" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[descriptionEN]}</textarea>
</div>
<div class="tab-pane" id="MyFRtab">
<label><input type="checkbox" id="RT_FR"> Request a translation</label><br>
<small>If you enable this checkbox, the request for a new translation will be completed within a few minutes after saving this article in the "Published" mode.</small>
<h4>Title:</h4>
<input id="posttitleFR" type="text" value="{$blog_post[titleFR]}" style="width:100%;padding:5px;">
<h4>Introduction:</h4>
<textarea id="subheadFR" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[subheadFR]}</textarea>
<h4>HTML body of the article:</h4>
<textarea id="postbodyFR" class="form-control" style="margin-top:10px;width:100%;height: 80vh;resize:vertical;padding:5px;">{$blog_post[htmlFR]}</textarea>
<h4>OG-Description:</h4>
<textarea id="descriptionFR" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[descriptionFR]}</textarea>
</div>
<div class="tab-pane" id="MyDEtab">
<label><input type="checkbox" id="RT_DE"> Request a translation</label><br>
<small>If you enable this checkbox, the request for a new translation will be completed within a few minutes after saving this article in the "Published" mode.</small>
<h4>Title:</h4>
<input id="posttitleDE" type="text" value="{$blog_post[titleDE]}" style="width:100%;padding:5px;">
<h4>Introduction:</h4>
<textarea id="subheadDE" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[subheadDE]}</textarea>
<h4>HTML body of the article:</h4>
<textarea id="postbodyDE" class="form-control" style="margin-top:10px;width:100%;height: 80vh;resize:vertical;padding:5px;">{$blog_post[htmlDE]}</textarea>
<h4>OG-Description:</h4>
<textarea id="descriptionDE" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[descriptionDE]}</textarea>
</div>
<div class="tab-pane" id="MyEStab">
<label><input type="checkbox" id="RT_ES"> Request a translation</label><br>
<small>If you enable this checkbox, the request for a new translation will be completed within a few minutes after saving this article in the "Published" mode.</small>
<h4>Title:</h4>
<input id="posttitleES" type="text" value="{$blog_post[titleES]}" style="width:100%;padding:5px;">
<h4>Introduction:</h4>
<textarea id="subheadES" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[subheadES]}</textarea>
<h4>HTML body of the article:</h4>
<textarea id="postbodyES" class="form-control" style="margin-top:10px;width:100%;height: 80vh;resize:vertical;padding:5px;">{$blog_post[htmlES]}</textarea>
<h4>OG-Description:</h4>
<textarea id="descriptionES" class="form-control" rows="5" style="margin-top:10px;width:100%;height:auto;resize:vertical;padding:5px;">{$blog_post[descriptionES]}</textarea>

</div>
<div class="tab-pane active" id="Mypost">
<form class="form-horizontal" action="javascript:void(0);">
<div class="input-group">
<div id="authordiv" style="display:none;">
{$authorslist}
</div>
<div id="emotiondiv" style="white-space: nowrap; display: inline-block; margin-right: 10px;"><a id="emotioninner" href="javascript:void(0)" onclick="choisemood(0)">Choose your mood</a><span id="inputemotion" style="display: none;"><input type="hidden" name="emotiontext" id="emotiontext" value=""></span></div>
<input type="hidden" id="emotionid" name="emotionid" value="{$emotionid}">
<div id="moods" style="display: none; margin: 5px;" align="left">
<div id="emotion1" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(1)">
<img src="images/emotions/1.png" border="0" width="20" height="20"> <span id="emotiontext1">crying</span>
</div>
<div id="emotion2" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(2)">
<img src="images/emotions/2.png" border="0" width="20" height="20"> <span id="emotiontext2">with pleasure</span>
</div>
<div id="emotion3" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(3)">
<img src="images/emotions/3.png" border="0" width="20" height="20"> <span id="emotiontext3">surprised</span>
</div>
<div id="emotion4" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(4)">
<img src="images/emotions/4.png" border="0" width="20" height="20"> <span id="emotiontext4">puzzled</span>
</div>
<div id="emotion5" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(5)">
<img src="images/emotions/5.png" border="0" width="20" height="20"> <span id="emotiontext5">cool</span>
</div>
<div id="emotion6" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(6)">
<img src="images/emotions/6.png" border="0" width="20" height="20"> <span id="emotiontext6">enamored</span>
</div>
<div id="emotion7" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(7)">
<img src="images/emotions/7.png" border="0" width="20" height="20"> <span id="emotiontext7">kidding</span>
</div>
<div id="emotion8" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(8)">
<img src="images/emotions/8.png" border="0" width="20" height="20"> <span id="emotiontext8">flirt</span>
</div>
<div id="emotion9" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(9)">
<img src="images/emotions/9.png" border="0" width="20" height="20"> <span id="emotiontext9">I smile</span>
</div>
<div id="emotion10" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(10)">
<img src="images/emotions/10.png" border="0" width="20" height="20"> <span id="emotiontext10">broken heart</span>
</div>
<div id="emotion11" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(11)">
<img src="images/emotions/11.png" border="0" width="20" height="20"> <span id="emotiontext11">angry</span>
</div>
<div id="emotion12" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(12)">
<img src="images/emotions/12.png" border="0" width="20" height="20"> <span id="emotiontext12">sad</span>
</div>
<div id="emotion13" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(13)">
<img src="images/emotions/13.png" border="0" width="20" height="20"> <span id="emotiontext13">I wink</span>
</div>
<div id="emotion14" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(14)">
<img src="images/emotions/14.png" border="0" width="20" height="20"> <span id="emotiontext14">I am confused</span>
</div>
<div id="emotion15" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(15)">
<img src="images/emotions/15.png" border="0" width="20" height="20"> <span id="emotiontext15">I am happy</span>
</div>
<div id="emotion16" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(16)">
<img src="images/emotions/16.png" border="0" width="20" height="20"> <span id="emotiontext16">I am boring</span>
</div>
<div id="emotion17" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(17)">
<img src="images/emotions/17.png" border="0" width="20" height="20"> <span id="emotiontext17">Bingo</span>
</div>
<div id="emotion18" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(18)">
<img src="images/emotions/18.png" border="0" width="20" height="20"> <span id="emotiontext18">I am thinking</span>
</div>
<div id="emotion19" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(19)">
<img src="images/emotions/19.png" border="0" width="20" height="20"> <span id="emotiontext19">busy</span>
</div>
<div id="emotion20" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(20)">
<img src="images/emotions/20.png" border="0" width="20" height="20"> <span id="emotiontext20">glad</span>
</div>
<div id="emotion21" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(21)">
<img src="images/emotions/21.png" border="0" width="20" height="20"> <span id="emotiontext21">I am sleeping</span>
</div>
<div id="emotion22" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(22)">
<img src="images/emotions/22.png" border="0" width="20" height="20"> <span id="emotiontext22">annoyed</span>
</div>
<div id="emotion23" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(23)">
<img src="images/emotions/23.png" border="0" width="20" height="20"> <span id="emotiontext23">I am furious</span>
</div>
<div id="emotion24" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(24)">
<img src="images/emotions/24.png" border="0" width="20" height="20"> <span id="emotiontext24">I laugh</span>
</div>
<div id="emotion25" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(25)">
<img src="images/emotions/25.png" border="0" width="20" height="20"> <span id="emotiontext25">no comments</span>
</div>
<div id="emotion26" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(26)">
<img src="images/emotions/26.png" border="0" width="20" height="20"> <span id="emotiontext26">don't understand</span>
</div>
<div id="emotion27" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(27)">
<img src="images/emotions/27.png" border="0" width="20" height="20"> <span id="emotiontext27">I am in shocked</span>
</div>
<div id="emotion28" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(28)">
<img src="images/emotions/28.png" border="0" width="20" height="20"> <span id="emotiontext28">I am drunk</span>
</div>
<div id="emotion29" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(29)">
<img src="images/emotions/29.png" border="0" width="20" height="20"> <span id="emotiontext29">I am afraid</span>
</div>
<div id="emotion30" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(30)">
<img src="images/emotions/30.png" border="0" width="20" height="20"> <span id="emotiontext30">in search of adventure</span>
</div>
<div id="emotion31" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion" onclick="choisemood(31)">
<img src="images/emotions/31.png" border="0" width="20" height="20"> <span id="emotiontext31">I resent</span>
</div>
<div id="noemotion" class="col-lg-3 col-md-4 col-sm-5 col-xs-6 emotion">
<a href="javascript:void(0)" onclick="choisemood(-1)">No emotions</a>
</div>
</div>
</div>
<div id="postlocationdiv" class="input-group" style="margin-bottom: 10px;">
<input type="hidden" name="latitude" id="latitude" value="">
<input type="hidden" name="longitude" id="longitude" value="">
<div class="input-group-addon"><button type="button" class="btn btn-default btn-xs" onclick="locationdetect(false)"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> <button type="button" class="btn btn-default btn-xs" onclick="locationdetect(true)"><span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span> {$autodetection}</button></div> <input type="text" name="postlocation" id="postlocation" value="" placeholder="My location" class="form-control input-sm">
</div>
<div id="titlediv" class="input-group" style="margin-bottom: 10px;">
<span class="input-group-addon">Title:</span>
<input type="text" class="form-control" name="posttitle" id="posttitle" value="{$blog_post[title]}" placeholder="The title of your post">
</div>
<div id="subheaddiv" style="display:none;margin-bottom:10px;">
<h4>Introduction:</h4>
<textarea id="subhead" class="form-control" rows="5" style="width:100%;height:auto;resize:vertical;">{$blog_post[subhead]}</textarea>
</div>
<div id="pricediv" class="form-inline" style="margin-bottom: 10px;">
	<div class="input-group">
	<span class="input-group-addon">Selling price:</span>
	<input type="number" step="0.01" min="0" placeholder="0,00" class="form-control" name="price" id="price" value="{$blog_post[price]}" style="width: 150px;" onkeyup="this.value = this.value.replace(/[^0-9\.]/g, '')">
	</div>
	<div class="input-group">
	{$curr_html}
	</div>
</div>
<textarea id="editor">{$blog_post[post_html]}</textarea>
<div id="previewmodal" class="modal fade">
	<div class="modal-content">
	  <div class="modal-header">
		<span style="float: left;" id="previewtitle"></span><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	  </div>
	  <div style="padding: 10px 10px 10px; height: 100%; overflow: auto;" id="result"></div>
	  <div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close preview</button>
	  </div>
	</div>
</div>

<script>
   $(document).on('focusin', function (e) {
        if ($(e.target).closest(".mce-window, .moxman-window").length) {
            e.stopImmediatePropagation();
        }
    });
</script>			

<input type="file" id="UserFile" style="display:none;" disabled>
<button id="uploadbutton" class="btn btn-default" onclick="uploadclick()" style="margin-top:10px;"><span class="glyphicon glyphicon-paperclip"></span> Attach file</button>

<h3>Categories:</h3>
<div class="input-group">
<input type="hidden" id="postcategories" name="postcategories" value="{$postcategories}">
<div id="categorylist">
</div>
</div>
<div class="input-group" style="margin-top: 10px;">
	<span class="input-group-addon">{$phrase['Tags:']}</span>
	<input id="posttags" value="{$tags}" data-role="tagsinput" style="display: none;" type="text"> <button class="btn btn-info" id="tagsbtn" onclick="tagsmaster()">Auto-tags</button><img id="tagsloading" src="/images/loading.gif" style="width:30px;display:none;">
	<script>
	$('#posttags').tagsinput({
	 maxTags: 25
	});
	$('input').on('beforeItemAdd', function(event) {
		canupload = false;
		setTimeout(function(){canupload = true;},1000);
	});
	</script>
</div>

<div style="text-align:center;">
<button type="button" id="savebutton" class="btn btn-primary" style="margin-top: 10px; display: inline-block;" onclick="savepost();">Save post</button> <button type="button" class="btn btn-danger deletebutton" style="margin-top: 10px; display: inline-block; float: right;" onclick="deletepost();">Delete</button>
</div>					
	
<div class="radio" id="posttypediv">
<h3>Post type:</h3>
  <label>
    <input type="radio" name="posttype" id="posttype0" value="0">
    <span>Article</span>&nbsp;&nbsp;&nbsp;
  </label>
  <label>
    <input type="radio" name="posttype" id="posttype1" value="1">
    <span>Petition (collecting signatures)</span>
  </label>
</div>					

<div class="radio">
<h3>Who can read this post:</h3>
  <label>
    <input type="radio" name="accessmode" id="accessmode0" value="0">
    <span>Everyone</span>&nbsp;&nbsp;&nbsp;
  </label>
  <label>
    <input type="radio" name="accessmode" id="accessmode1" value="1">
    <span>Only I (draft)</span>
  </label>
</div>					

<div class="radio">
<h3>Comments:</h3>
  <label>
    <input type="radio" name="commentsmode" id="commentsmode0" value="0">
    <span>Comments are allowed</span>&nbsp;&nbsp;&nbsp;
  </label>
  <label>
    <input type="radio" name="commentsmode" id="commentsmode1" value="1">
    <span>Comments are allowed</span>, <span>without notification</span>&nbsp;&nbsp;&nbsp;
  </label>
  <label>
    <input type="radio" name="commentsmode" id="commentsmode2" value="2">
    <span>Comments are closed</span>
  </label>
</div>		
			
<div class="input-group" style="margin-top: 10px;">
	<label>
	  <input type="checkbox" name="showcomments" id="showcomments"> <span>Comments are visible to everyone (if disabled, comments will be visible only to you).</span>
	</label>
</div>

<div class="radio">
<h3>Receive donations from readers:</h3>
  <label>
    <input type="radio" name="donates" id="donates1" value="1">
    <span>Yes (recommended)</span>&nbsp;&nbsp;&nbsp;
  </label>
  <label>
    <input type="radio" name="donates" id="donates0" value="0">
    <span>No, don't want</span>
  </label>
</div>					
	<div class="input-group" style="margin-top: 10px; width: 100%;">
		<h3>The short description:</h3>
		<textarea id="postdescription" class="form-control" rows="2">{$blog_post[description]}</textarea><small>no more than 320 characters</small> * <small>this field can be generated automatically after writing this post</small><br />
		<strong>Image for social networks:</strong>&nbsp; <a href="javascript:void(0)" onclick="gopictab()"><span id="thumbnailfilename"></span></a>&nbsp; <button type="button" class="btn btn-default" onclick="gopictab()">Gallery</button> <button type="button" class="btn btn-default" onclick="selectthumbnail('','');"><span class="glyphicon glyphicon-remove"></span></button> 
	</div>
	<div class="input-group" style="margin-top: 10px;">
		<h3>The time of publication:</h3>
		<div class="input-group date form_datetime col-md-12" data-link-field="dtp_input1">
			<input id="posttime" class="form-control" size="30" type="text" value="{$posttime}" placeholder="if not specified, then immediately" readonly>
			<span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
			<span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
		</div><small style="margin-left: 10px;">Your time zone:</small> {$user_utc_str} <small>(<a href="{$profile_href}" target="_blank">profile settings</a>)</small>
		<input type="hidden" id="dtp_input1" value="" />
		<script>
			$('.form_datetime').datetimepicker({
				{$datetimepicker_locale}
				weekStart: {$weekstart},
				todayBtn:  1,
				autoclose: 1,
				todayHighlight: 1,
				startView: 2,
				forceParse: 0,
				showMeridian: 1,
				calendarWeeks: 1,
				format: 'yyyy-mm-dd hh:ii'
			});
		</script>
	</div>
	<div class="input-group" style="margin-top: 10px;display:none;">
		<label>
		  <input type="checkbox" name="nolng" id="nolng"> <span><b>Disable translating a post into other languages</b></span>
		</label>
	</div>
	<div class="input-group" style="margin-top: 10px;">
		<label>
		  <input type="checkbox" name="attached" id="attached"> <span><b>Pin this post</b></span>
		</label>
	</div>
	</form>
	<div style="text-align:center;">
	<button type="button" id="savebutton" class="btn btn-primary" style="margin-top: 10px; display: inline-block;" onclick="savepost();">Save post</button> <button type="button" class="btn btn-danger deletebutton" style="margin-top: 10px; display: inline-block; float: right;" onclick="deletepost();">Delete</button>
	</div>					
	</div>
	<div class="tab-pane" id="Mypictures">
		<h3>Library of your images:</h3>
		<a href="javascript:void(0)" onclick="goposttab()">&larr; <span>Back to editing</span></a><br /><br />
		<div style="display: inline-block;">
		<button type="button" id="addpicture" class="btn btn-default" style="margin-bottom: 10px;" onclick="addpicture(0);">Add picture</button>
		</div>
		<div id="data-container" style="width:100%; background: #fff;" align="left">
		</div>
		{$pictures_html}
	</div>
  </div>
</div>

<div id="newpicture" class="modal fade">
  <div class="modal-dialog">
	<div class="modal-content">
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h4 class="modal-title">Picture</h4>
	  </div>
	  <div style="padding: 10px 10px 10px;">
				<form class="form-vertical" action="javascript:void(0);">
				<input type="hidden" name="filename" id="filename" value="">
				<div class="file-field">
					<div style="vertical-align: middle; margin: 2px; white-space: nowrap; width: 100%;">
					<img id="editphoto" src="./images/no-image.png" style="max-width: 100%; max-height: 300px;">
					</div>
					<div id="selectfile" class="btn btn-primary btn-sm" style="display: inline-block;">
						<input type="file" id="PhotoFile" name="PhotoFile" onchange="showeditphoto();"> 
						<input class="form-control" type="hidden" id="photo_b64" name="photo_b64">
					</div>
					<div class="input-group" style="margin-top: 10px;">
						<span>Description or keywords:</span><small style="float: right;">No more than 50 characters</small>
						<input type="text" class="form-control" name="description" id="description" value="">
					</div>
				</div>
				</form>
	  </div>
	  <div class="modal-footer">
			<div id="deletediv" class="checkbox has-error" style="display: inline-block; white-space: nowrap; float: left;">
			<label>
			  <input type="checkbox" name="todelete" id="todelete"> <span>Delete file</span>
			</label>
			</div>
			<div style="display: inline-block; white-space: nowrap;">
			<button id="cancelimgbutton" type="button" class="btn btn-default" data-dismiss="modal">Cancel changes</button>
			<button id="saveimgbutton" type="button" class="btn btn-primary" onclick="saveimage()">Save changes</button>
		</div>
	  </div>
	</div>
  </div>
</div>
		
</div>

<div id="uploadingwin" class="modal fade">
  <div class="modal-dialog">
	<div class="modal-content">
	  <div class="modal-header">
		<h4 class="modal-title">Uploading file<span id="progressperc"></span></h4>
	  </div>
	  <div style="padding: 10px 10px 10px;">
			<div id="progressbar" class="progress">
				<div id="progressline" class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="0" style="width: 0%">
				</div>
			</div>
			<div id="filechecking" style="display:none;color:#666;text-align:center;"><strong>checking...</strong><br /><img src="/images/checkfile.gif" style="width:70px;height:auto;"></div>
	  </div>
	</div>
  </div>
</div>
<div class="trnsltphrss">
<span>Error</span>
<span>You must select an author!</span>
<span>File is too big!</span>
<span>Download:</span>
<span>This image is used in the publication!</span>
<span>Insert image</span>
<span>Save changes</span>
<span>Please pay attention!</span>
<span>Upload image</span>
<span>Specify the title of this post!</span>
<span>The title of your post</span>
<span>The minimum length of the post - 30 characters.</span>
<span>The length of the text can not be more than 60000 characters!</span>
<span>The current text length - </span>
<span>You must specify the price of the goods!</span>
<span>Description of emotion should not be more than 30 characters!</span>
<span>Too many tags!</span>
<span>My location</span>
<span>The text of the post must be unique!</span>
<span>Are you sure you want to remove this post?</span>
<span>The removal of the post</span>
<span>Sorry, there was some error with the request. Please refresh the page.</span>
<span>This picture was chosen as the main picture. You can not make changes right now!</span>
<span>if not specified, then immediately</span>
<span>You did not choose the period of placement of the advertising post!</span>
<span>This is an advertising post.</span>
<span>If you delete it, the funds for its publication will NOT be returned!</span>
<span>If you delete it, the amount of previously received income will be canceled.</span>
<span>Description should not be more than 320 characters!</span>
</div>
{$footer}
<!-- <script src="/js/tinymcepositions.js"></script> -->
</body>
</html>
