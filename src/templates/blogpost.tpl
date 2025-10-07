<script>
loadingcomments = 0;
var stayed_Id = 0;
function js_translate(str) {
if (str == '{$phraseclose}') { str = '{$btn_close}'; } if (str == 'Close') { str = '{$btn_close}'; }
if (str == '{$phraseok}') { str = '{$btn_ok}'; }
if (str == '{$phrasecancel}') { str = '{$btn_cancel}'; }
if (str == '{$phraseyes}') { str = '{$btn_yes}'; }
if (str == '{$phraseno}') { str = '{$btn_no}'; }
return str;
}
function untime(){
	return parseInt(new Date().getTime()/1000)
}
function fromunixtime() {
	for(var i=0;i<$('.commentd').get().length;i++)
	{
		datetext = $('.commentd:eq(' + i + ')').text();
		if (datetext.indexOf('unixtime') + 1)
		{
			datetext = datetext.replace('unixtime','');
			$('.commentd:eq(' + i + ')').text(timestamp2date(datetext));
			$('.commentdiff:eq(' + i + ')').text();
		}
	}
	$(".commentd").removeClass("commentd");
	$(".commentdiff").removeClass("commentdiff");
}
function getcomments(startid) {
	loadingcomments = 1;
	$.ajax({
		url: './getcomments.php',
		type: 'GET',
		async: false,
		data: {object_id: 'posts{$postid}', startid: startid, gocomment: gocomment, community: '{$community}' },
		success: function(response) {
			$(".endcomments").remove();
			document.getElementById('loadingcomments').style.display = 'none';
			if (startid == 0)
			{
				$('#commentsblock').html(response);
			}
			else
			{
				$('#commentsblock').append(response);
			}
			fromunixtime();
			loadingcomments = 0;
			showcomments();
			$('[data-toggle="tooltip"]').tooltip();
		},
		error: function(response) {
			document.getElementById('loadingcomments').style.display = 'none';
			loadingcomments = 0;
		},
		timeout: 10000
	});
}
function showcomments() {
	var $win = $(window);
	var $endofpost = $('.endofpost:first');
	if(stayed_Id == 0 && $win.scrollTop() + $win.height() >= $endofpost.offset().top) {
		stayed_Id = setTimeout(function() {
			reg_stayed();
		}, 1);
	}
	if (loadingcomments == 0)
	{
		for(var i=0;i<$('.endcomments').get().length;i++)
		{
			fromid = $('.endcomments:eq(' + i + ')').attr('id');
			var item = document.getElementsByClassName('endcomments');
			var itemFirst = item[i];
			if (elementInViewport(itemFirst) || publishtime == 0)
			{
				getcomments(fromid);
			}
		}
	}
}
function copycommentlink(commentid) {
	url = '{$thispageurl}#comment'+commentid;
	bootpopup({
		title: "Link to comment",
		content: [
		'<p>Highlight and copy this link:</p>',
		'<input id="commenturl" type="text" style="width: 100%; line-height: 1.5em; font-size: 1em" value="'+url+'" onclick="$(this).select();" readonly>'
			],
		ok: function(data, array, event) { return false; }
	});
}
function votepost(postid,votemode) {
	if (votemode == 1)
	{
		if (document.getElementById('postpluscount').innerHTML == '&nbsp;')
		{
			document.getElementById('postpluscount').innerHTML = 0;
		}
		if ( $('#thumbsup').hasClass('postvote') )
		{
			$('#thumbsup').removeClass('postvote');
			$('#thumbsup').addClass('postvotedplus');
			document.getElementById('postpluscount').innerHTML = document.getElementById('postpluscount').innerHTML * 1 + 1;
		}
		else if ( $('#thumbsup').hasClass('postvotedplus') )
		{
			$('#thumbsup').removeClass('postvotedplus');
			$('#thumbsup').addClass('postvote');
			document.getElementById('postpluscount').innerHTML = document.getElementById('postpluscount').innerHTML * 1 - 1;
		}
		if ( $('#thumbsdown').hasClass('postvotedminus') )
		{
			$('#thumbsdown').removeClass('postvotedminus');
			$('#thumbsdown').addClass('postvote');
		}
	}
	if (votemode == 0)
	{
		if ( $('#thumbsdown').hasClass('postvote') )
		{
			$('#thumbsdown').removeClass('postvote');
			$('#thumbsdown').addClass('postvotedminus');
		}
		else if ( $('#thumbsdown').hasClass('postvotedminus') )
		{
			$('#thumbsdown').removeClass('postvotedminus');
			$('#thumbsdown').addClass('postvote');
		}
		if ( $('#thumbsup').hasClass('postvotedplus') )
		{
			$('#thumbsup').removeClass('postvotedplus');
			$('#thumbsup').addClass('postvote');
			document.getElementById('postpluscount').innerHTML = document.getElementById('postpluscount').innerHTML * 1 - 1;
		}
	}
	$.post( "./postvote.php", { checkID: {$startruntime}, postid: postid, votemode: votemode, community: '{$community}' })
	  .done(function( data ) {
		data = $.parseJSON(data);
		if (data[0] == 'plus' || data[0] == 'minus' || data[0] == 'none')
		{
			if (data[0] == 'plus')
			{
				if ( $('#thumbsup').hasClass('postvote') )
				{
					$('#thumbsup').removeClass('postvote');
				}
				$('#thumbsup').addClass('postvotedplus');
				if ( $('#thumbsdown').hasClass('postvotedminus') )
				{
					$('#thumbsdown').removeClass('postvotedminus');
				}
				$('#thumbsdown').addClass('postvote');
			}
			if (data[0] == 'minus')
			{
				if ( $('#thumbsdown').hasClass('postvote') )
				{
					$('#thumbsdown').removeClass('postvote');
				}
				$('#thumbsdown').addClass('postvotedminus');
				if ( $('#thumbsup').hasClass('postvotedplus') )
				{
					$('#thumbsup').removeClass('postvotedplus');
				}
				$('#thumbsup').addClass('postvote');
			}
			if (data[0] == 'none')
			{
				if ( $('#thumbsup').hasClass('postvotedplus') )
				{
					$('#thumbsup').removeClass('postvotedplus');
				}
				$('#thumbsup').addClass('postvote');
				if ( $('#thumbsdown').hasClass('postvotedminus') )
				{
					$('#thumbsdown').removeClass('postvotedminus');
				}
				$('#thumbsdown').addClass('postvote');
			}
			document.getElementById('postpluscount').innerHTML = '&nbsp;';
			if (data[1] > 0 && data[1]-1 > 0)
			{
				document.getElementById('postpluscount').innerHTML = data[1]-1;
			}
		}
	});
}
function votecomment(commentid,objectid,votemode) {
	if (votemode == 1)
	{
		if (document.getElementById('pluscount'+commentid).innerHTML == '&nbsp;')
		{
			document.getElementById('pluscount'+commentid).innerHTML = 0;
		}
		if ( $('#thumbsup'+commentid).hasClass('vote') )
		{
			$('#thumbsup'+commentid).removeClass('vote');
			$('#thumbsup'+commentid).addClass('votedplus');
			document.getElementById('pluscount'+commentid).innerHTML = document.getElementById('pluscount'+commentid).innerHTML * 1 + 1;
		}
		else if ( $('#thumbsup'+commentid).hasClass('votedplus') )
		{
			$('#thumbsup'+commentid).removeClass('votedplus');
			$('#thumbsup'+commentid).addClass('vote');
			document.getElementById('pluscount'+commentid).innerHTML = document.getElementById('pluscount'+commentid).innerHTML * 1 - 1;
		}
		if ( $('#thumbsdown'+commentid).hasClass('votedminus') )
		{
			$('#thumbsdown'+commentid).removeClass('votedminus');
			$('#thumbsdown'+commentid).addClass('vote');
		}
	}
	if (votemode == 0)
	{
		if (document.getElementById('minuscount'+commentid).innerHTML == '&nbsp;')
		{
			document.getElementById('minuscount'+commentid).innerHTML = 0;
		}
		if ( $('#thumbsdown'+commentid).hasClass('vote') )
		{
			$('#thumbsdown'+commentid).removeClass('vote');
			$('#thumbsdown'+commentid).addClass('votedminus');
			document.getElementById('minuscount'+commentid).innerHTML = document.getElementById('minuscount'+commentid).innerHTML * 1 + 1;
		}
		else if ( $('#thumbsdown'+commentid).hasClass('votedminus') )
		{
			$('#thumbsdown'+commentid).removeClass('votedminus');
			$('#thumbsdown'+commentid).addClass('vote');
			document.getElementById('minuscount'+commentid).innerHTML = document.getElementById('minuscount'+commentid).innerHTML * 1 - 1;
		}
		if ( $('#thumbsup'+commentid).hasClass('votedplus') )
		{
			$('#thumbsup'+commentid).removeClass('votedplus');
			$('#thumbsup'+commentid).addClass('vote');
			document.getElementById('pluscount'+commentid).innerHTML = document.getElementById('pluscount'+commentid).innerHTML * 1 - 1;
		}
	}
	$.post( "./commentvote.php", { checkID: {$startruntime}, commentid: commentid, object_id: objectid, votemode: votemode, community: '{$community}' })
	  .done(function( data ) {
		data = $.parseJSON(data);
		if (data[0] == 'plus' || data[0] == 'minus' || data[0] == 'none')
		{
			if (data[0] == 'plus')
			{
				if ( $('#thumbsup'+commentid).hasClass('vote') )
				{
					$('#thumbsup'+commentid).removeClass('vote');
				}
				$('#thumbsup'+commentid).addClass('votedplus');
				if ( $('#thumbsdown'+commentid).hasClass('votedminus') )
				{
					$('#thumbsdown'+commentid).removeClass('votedminus');
				}
				$('#thumbsdown'+commentid).addClass('vote');
			}
			if (data[0] == 'minus')
			{
				if ( $('#thumbsdown'+commentid).hasClass('vote') )
				{
					$('#thumbsdown'+commentid).removeClass('vote');
				}
				$('#thumbsdown'+commentid).addClass('votedminus');
				if ( $('#thumbsup'+commentid).hasClass('votedplus') )
				{
					$('#thumbsup'+commentid).removeClass('votedplus');
				}
				$('#thumbsup'+commentid).addClass('vote');
			}
			if (data[0] == 'none')
			{
				if ( $('#thumbsup'+commentid).hasClass('votedplus') )
				{
					$('#thumbsup'+commentid).removeClass('votedplus');
				}
				$('#thumbsup'+commentid).addClass('vote');
				if ( $('#thumbsdown'+commentid).hasClass('votedminus') )
				{
					$('#thumbsdown'+commentid).removeClass('votedminus');
				}
				$('#thumbsdown'+commentid).addClass('vote');
			}
			document.getElementById('pluscount'+commentid).innerHTML = '&nbsp;';
			document.getElementById('minuscount'+commentid).innerHTML = '&nbsp;';
			if (data[1] > 0 && data[1]-1 > 0)
			{
				document.getElementById('pluscount'+commentid).innerHTML = data[1]-1;
			}
			if (data[2] > 0 && data[2]-1 > 0)
			{
				document.getElementById('minuscount'+commentid).innerHTML = data[2]-1;
			}
		}
	});
}
function savecomment(replytoid,commentid) {
	tinyMCE.triggerSave();
	if (commentid < 0)
	{
		commentid = document.getElementById('editcommentid').value;
	}
	if (commentid == 0)
	{
		var comment = $('#editor').val();
		document.getElementById('savecomment').style.display = 'none';
	}
	else
	{
		var comment = $('#commenteditor').val();
	}
	privatecomment = 0;
	if (document.getElementById('privatecomment'))
	{
		if (document.getElementById('privatecomment').checked)
		{
			privatecomment = 1;
		}
	}
	if (comment.length < 5)
	{
		document.getElementById('savecomment').style.display = 'inline-block';
		bootpopup.alert('The minimum length of the comment - 5 characters.','Please pay attention!');
		return;
	}
	$.post( "./savecomment.php", { privatecomment: privatecomment, comment: comment, object_id: 'posts{$postid}', replytoid: replytoid, commentid: commentid, checkID: {$startruntime}, community: '{$community}' })
	  .done(function( data ) {
		if (data > 0)
		{
			if (commentid > 0)
			{
				document.getElementById('textcomment'+commentid).innerHTML = comment;
			}
			else
			{
				replyto(0);
				$.ajax({
					url: './getcomments.php',
					type: 'GET',
					async: true,
					data: {object_id: 'posts{$postid}', commentid: data, community: '{$community}' },
					success: function(response) {
						if (replytoid > 0)
						{
							$('div.comment'+replytoid+':first').after(response);
						}
						else
						{
							$('#replyto0').after(response);
						}
						fromunixtime();
						$(".js-smartPhoto").SmartPhoto();
					},
					error: function(response) {
						location.href='{$thispageurl}';
					}
				});
			}
			lastcommentedit = 0;
		}
		else
		{
			bootpopup.alert(data,'Please pay attention!');
		}
		if (commentid == 0)
		{
			document.getElementById('savecomment').style.display = 'inline-block';
		}
	});
}
function deletecomment(commentid) {
	var allcomments = 0;
	authorname = document.getElementById('author'+commentid).innerHTML;
	bootpopup({
		title: 'Delete comment'+' #'+commentid,
		content: [
		'Are you sure you want to delete this comment?<br />',
		'<label><input id="allcomments" name="allcomments" type="checkbox"> Delete all comments <b>'+authorname+'</b></label><br />'
			],
		cancel: function(data, array, event) { return false; },
		ok: function(data, array, event) {
			if (data.allcomments == 'on')
			{
				var allcomments = 1;
			}
			else
			{
				$("div.comment"+commentid).remove();
			}
			replyto(0);
			$.post( "./removecomment.php", { checkID: {$startruntime}, object_id: 'posts{$postid}', commentid: commentid, allcomments: allcomments, community: '{$community}' })
			  .done(function( data ) {
			});
			if (allcomments == 1)
			{
				getcomments(0);
			}
		}
	});
}
function replyto(commentid) {
	tinymce.remove();
	document.getElementById('replyto'+lastcommentedit).innerHTML = '';
	if (commentid == 0)
	{
		document.getElementById('postcomment').style.display = 'none';
	}
	else
	{
		document.getElementById('postcomment').style.display = 'inline-block';
	}
	lastcommentedit = commentid;
	privatedisplay = 'none';
	if (commentid == 0)
	{
		privatedisplay = 'block';
	}
	document.getElementById('replyto'+commentid).innerHTML = '<textarea id="editor"></textarea><div style="display:' + privatedisplay + ';"><label><input type="checkbox" id="privatecomment"> Hidden comment</label>&nbsp;<a href="javascript:void(0);" data-toggle="tooltip" title="Hidden comments are available only to the author of the publication and you." style="font-weight:600;"><small>?</small></a></div><button id="savecomment" type="button" class="btn btn-primary" style="display: inline-block; margin-top: 5px; margin-bottom: 10px;" onclick="savecomment('+ commentid +',0);">Save comment</button><br />';
	$('[data-toggle="tooltip"]').tooltip();
	activeEditor = tinymce.init({
		selector: '#editor',
		toolbar: 'undo redo | tinymceEmoji | link myimage media | ltr rtl',
		plugins: "autoresize advlist autolink link imagetools media visualblocks visualchars tinymceEmoji directionality",
		autoresize_bottom_margin: 30,
		emoji_add_space: true,
		emoji_show_subgroups: false,
		emoji_show_tab_icons: true,
		paste_as_text: true,
		branding: false,
		menubar:false,
		relative_urls: false,
		remove_script_host: true,
		statusbar: false,
		image_advtab: false,
		force_p_newlines: false,
		invalid_styles: 'color font-size font background',
		remove_trailing_brs: false,
		forced_root_block: false,
		keep_styles: false,
		{$tinymcelng}
		invalid_elements: 'p,span,lang,strong,b',
		setup: function (editor) {
			editor.addButton('myimage', {
			  text: false,
			  icon: 'image',
			  tooltip: "Upload image",
			  onclick: function () {
				addpicture(-1);
			  }
			});
		}
	});
	$('#editor').html('');
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
	document.getElementById('loadingphoto').style.display = 'none';
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
function showeditphoto() {
	var image = $("#PhotoFile");
	if (image[0].files && image[0].files[0]) {
		resizeFile(image[0].files[0], $('#editphoto'), $('#photo_b64'))
	}
}
function resizeFile(file, editphoto, b64field) {
	document.getElementById('loadingphoto').style.display = 'block';
	var reader = new FileReader();
    reader.onloadend = function () {
        var tempImg = new Image();
        tempImg.src = reader.result;
        tempImg.onload = function () {
            var tempW = tempImg.width;
            var tempH = tempImg.height;
            imgcrop(this, tempW, tempH, 900, 600, b64field);
            $(editphoto).attr('src', $(b64field).val());
 			document.getElementById('loadingphoto').style.display = 'none';
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
function saveimage() {
	var photo_b64 = document.getElementById('photo_b64').value;
	var filename = document.getElementById('filename').value;
	var description = document.getElementById('description').value;
	if (photo_b64 == '' && filename == '')
	{
		return;
	}
	document.getElementById('saveimgbutton').disabled = true;
	document.getElementById('cancelimgbutton').disabled = true;
	document.getElementById('loadingphoto').style.display = 'block';
	$.post( "./loadpictures.php", { photo_b64: photo_b64, filename: filename, description: description, object_id: 'comments{$postid}' })
	  .done(function( data ) {
		if(!(data.indexOf('.jpg') + 1) && data != 'OK')
		{
			document.getElementById('saveimgbutton').disabled = false;
			document.getElementById('cancelimgbutton').disabled = false;
			document.getElementById('loadingphoto').style.display = 'none';
			bootpopup.alert(data,'Error');
		}
		else
		{
			document.getElementById('saveimgbutton').disabled = false;
			document.getElementById('cancelimgbutton').disabled = false;
			document.getElementById('loadingphoto').style.display = 'none';
			$("#newpicture").modal('hide');
			if (insmode == -1)
			{
				tinyMCE.activeEditor.insertContent('<a href="'+data+'" class="js-smartPhoto" target="_blank"><img style="max-width: 90%; max-height: 250px; margin: 5px;" src="'+data+'" /></a><br />&nbsp;');
				tinyMCE.activeEditor.focus();
			}
		}
	});
}
function editcomment(commentid) {
	textcomment = document.getElementById('textcomment'+commentid).innerHTML;
	document.getElementById('editcommentid').value = commentid;
	$('#editcomment').appendTo("body").modal('show');
	if (edited)
	{
		tinymce.remove('#commenteditor');
	}
	activeEditor = tinymce.init({
		selector: '#commenteditor',
		toolbar: 'undo redo | tinymceEmoji | link myimage media | ltr rtl',
		plugins: "advlist autolink link imagetools media visualblocks visualchars tinymceEmoji directionality",
		emoji_add_space: true,
		emoji_show_subgroups: false,
		emoji_show_tab_icons: true,
		paste_as_text: true,
		branding: false,
		menubar:false,
		statusbar: false,
		image_advtab: false,
		relative_urls: false,
		remove_script_host: true,
		force_p_newlines: false,
		invalid_styles: 'color font-size font background',
		remove_trailing_brs: false,
		forced_root_block: false,
		keep_styles: false,
		{$tinymcelng}
		invalid_elements: 'p,span,lang,strong,b',
		setup: function (editor) {
			editor.addButton('myimage', {
			  text: false,
			  icon: 'image',
			  tooltip: "Upload image",
			  onclick: function () {
				addpicture(-1);
			  }
			});
		}
	});
	edited = true;
	tinyMCE.activeEditor.setContent(textcomment);
}
function abusecomment(commentid) {
	if (!{$user_id})
	{
		loginform();
		return;
	}
	url = '{$thispageurl}#comment'+commentid;
	authorname = document.getElementById('author'+commentid).innerHTML;
	bootpopup({
		title: "Report abuse",
		content: [
		'Comment #<b>'+commentid+'</b><br />',
		'User: <b>'+authorname+'</b><br />',
		'A description of the problem or the essence of the claims:',
		{ textarea: {name: "abusetext", id: "abusetext", style: "width: 100%; height: 100px;"}}
			],
		cancel: function(data, array, event) { return false; },
		ok: function(data, array, event) {
			abusetext = data.abusetext;
			if (abusetext.length>0)
			{
				$.post( "./abuse.php", { checkID: {$startruntime}, postid: '{$postid}', commentid: commentid, abusetext: abusetext, url: url, community: '{$community}' })
				  .done(function( data ) {
					bootpopup.alert(data,'Please pay attention!');
				});
			}
			else
			{
				bootpopup.alert('Please describe the essence of the claims','Please pay attention! ');
			}
		}
	});
}
function abusepost() {
	if (!{$user_id})
	{
		loginform();
		return;
	}
	url = '{$thispageurl}';
	bootpopup({
		title: "Report abuse",
		content: [
		'If you believe that this page violates the rules of our service, let us know!<br /><br />',
		'A description of the problem or the essence of the claims:',
		{ textarea: {name: "abusetext", id: "abusetext", style: "width: 100%; height: 100px;"}}
			],
		cancel: function(data, array, event) { return false; },
		ok: function(data, array, event) {
			abusetext = data.abusetext;
			if (abusetext.length>0)
			{
				$.post( "./abuse.php", { checkID: {$startruntime}, postid: '{$postid}', abusetext: abusetext, url: url, community: '{$community}' })
				  .done(function( data ) {
					bootpopup.alert(data,'Please pay attention!');
				});
			}
			else
			{
				bootpopup.alert('Please describe the essence of the claims','Please pay attention! ');
			}
		}
	});
}
function banuser(ban_user_id, ban_username) {
	bootpopup({
		title: "Ban user",
		content: [
		'Are you sure you want to block this user?<br />',
		'User: <b>'+ban_username+'</b><br />',
		'Access to this community will be completely closed for '+ban_username+'<br />',
		'All publications and comments made by this user in your community will also be deleted.',
		'You can unlock the user later in the settings of your community.'
			],
		cancel: function(data, array, event) { return false; },
		ok: function(data, array, event) {
			$.post( "./banuser.php", { checkID: {$startruntime}, ban_user_id: ban_user_id, community: '{$community}' })
			  .done(function( data ) {
				bootpopup.alert(data,"Please pay attention!");
				getcomments(0);
			  });
		}
	});
}
function unbanuser(ban_user_id, ban_username) {
	bootpopup({
		title: "Unblock user",
		content: [
		'Are you sure you want to unblock this user?<br />',
		'User: <b>'+ban_username+'</b>'
			],
		cancel: function(data, array, event) { return false; },
		ok: function(data, array, event) {
			$.post( "./banuser.php", { checkID: {$startruntime}, ban_user_id: ban_user_id, unblock: 1, community: '{$community}' })
			  .done(function( data ) {
				bootpopup.alert(data,"Please pay attention!");
				getcomments(0);
			});
		}
	});
}
function buyform() {
	if (!{$user_id})
	{
		loginform();
		return;
	}
	$('#buywin').show();
}
function reg_stayed() {
	const xhr = new XMLHttpRequest();
	xhr.open('GET', "./regstayed.php?postid={$postid}");
	xhr.onreadystatechange = function() {
		if (xhr.readyState !== 4 || xhr.status !== 200) {
			return;
		}
		const response = xhr.responseText;
		if (response != 'OK')
		{
			var sec = response * 1000;
			if (sec > 0)
			{
				stayed_Id = setTimeout(function() {
					reg_stayed();
				}, sec);
			}
		}
		console.log(response);
	}
	xhr.send();
}
function getshared() {
	sharedposts = document.getElementsByClassName('sharedlink');
	for (var i = 0; i < sharedposts.length; i++) {
		sharedinn = sharedposts[i].innerHTML;
		sharedurl = sharedposts[i].getAttribute("data-shared-url");
		if(sharedurl !== null)
		{
			if (sharedinn.length > 10 && sharedurl.length > 5)
			{
				sharedurl = encodeURIComponent(sharedurl);
				sharedposts[i].setAttribute("onclick","window.open('/go/?url="+sharedurl+"', '_blank');");
			}
			else
			{
				sharedposts[i].remove();
			}
		}
	}
}
</script>
<div class="blockarticle">
{$bootstrap_message}
<div id="notifier">
</div>
<span class="endcomments" id="0"></span>
<div style="width:100%;">{$postcategorylinks}</div>

<main>
<article>
<h1 class="h1">{$post[title]}</h1>{$post[approveinfo]}{$postedit}
{$post[header]}
{$post[intro]}
<div style="overflow:hidden;">
{$subhead}
<div class="rich-text w-richtext">
{$post[post_html]}
</div>
<div style="overflow:hidden;width:100%">
<div style="display:inline-block;float:left;">
<div class="share">
  <div class="sharediv">
      <a href="javascript:void(0)" class="social_share" data-type="fb"><span class="nottranslate">facebook</span></a>
      <a href="javascript:void(0)" class="social_share" data-type="twitter"><span class="nottranslate">X-Twitter</span></a>
      <a href="javascript:void(0)" class="social_share hideinit just_US" data-type="reddit"><span class="nottranslate">Reddit</span></a>
      <a href="javascript:void(0)" class="social_share hideinit just_ru just_RU" data-type="vk"><span class="nottranslate">VKontakte</span></a>
      <a href="javascript:void(0)" class="social_share hideinit just_ru just_RU" data-type="ok"><span class="nottranslate">OK.ru</span></a>
      <a href="javascript:void(0)" class="social_share" data-type="whatsapp"><span class="nottranslate">WhatsApp</span></a>
      <a href="javascript:void(0)" class="social_share" data-type="telegram"><span class="nottranslate">telegram</span></a>
      <a href="javascript:void(0)" class="social_share" data-type="email"><span class="nottranslate">email</span></a>

  </div>
  <span class="sharemenu" onclick="$('.sharediv').show();"><span class="glyphicons glyphicons-share-alt" style="font-size:11px"></span>&nbsp;&nbsp;&nbsp;{$sharephrase}</span>
</div>
</div>
<div style="display:inline-block;float:right;">
{$post2pdflink}
</div>
</div>
</div>
</article>
</main>
<span class="endofpost"></span>
<div style="width:100%;display:block;">
{$petitionhtml}
{$promooffer}
{$post[epilog]}
<div class="page-footer">
{$post[rating]}
{$post[tags]}
<div id="buybutton" style="display: none;text-align:center;"><button class="btn btn-success btn-lg" onclick="buyform()"><span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span> {$post[priceinfo]}</button></div>
{$pagecontacts}
<br />
<br />

				<div id="commentsblock" style="margin-top: -15px;">
<span id="replyto0"></span>
				</div>
				<div id="loadingcomments" style="text-align: center;"><span>Loading...</span><br /><img src="/images/loading.gif" alt="Loading..." width="30"><br /><a href="{$thispageurl}">Click here if comments are not loaded</a></div>
</div>
</div>

<div style="text-align:center;width:100%;">
{$postlnglinkshtml}
</div>

<div style="text-align:center;width:100%;">
{$supportus}
</div>

<div class="separator"><div class="separator-container"><div class="line-color"></div></div></div>

<div class="latest-posts">
<div class="container">
<div class="section-title-text">New publications</div>
<div class="posts-wrapper">
<div class="posts-collection-list-wrapper w-dyn-list">
<div role="list" class="posts-collection-list w-dyn-items w-row">

<div role="listitem" class="_2-collection-item w-dyn-item w-col w-col-6">
<a href="{$adarticles[0][url]}" class="posts-image w-inline-block">
<img alt="" src="{$adarticles[0][image]}">
</a>
<div class="post-info-text">
<a href="{$adarticles[0][url]}" class="post-title w-inline-block">
<h2 class="h3">{$adarticles[0][title]}</h2>
</a>
<div class="post-author-text cc-small-thumbnail">
<div class="post-author cc-top-margin">Author:</div>
<a href="{$adarticles[0][authorurl]}" class="post-author">{$adarticles[0][author]}</a>
</div>
</div>
</div>

<div role="listitem" class="_2-collection-item w-dyn-item w-col w-col-6">
<a href="{$adarticles[1][url]}" class="posts-image w-inline-block">
<img alt="" src="{$adarticles[1][image]}">
</a>
<div class="post-info-text">
<a href="{$adarticles[1][url]}" class="post-title w-inline-block">
<h2 class="h3">{$adarticles[1][title]}</h2>
</a>
<div class="post-author-text cc-small-thumbnail">
<div class="post-author cc-top-margin">Author:</div>
<a href="{$adarticles[1][authorurl]}" class="post-author">{$adarticles[1][author]}</a>
</div>
</div>
</div>

</div>
</div>
</div>
</div>
</div>

<div class="banner not_ru"><a href="/russian-propaganda-on-facebook" class="banner-wrapper2 w-inline-block" style="padding:30px;"><div class="left-column"><img src="/projects/most/images/propaganda1/manipulation-algorithms-en.png" loading="lazy" alt=""></div><div class="right-column" style="padding: 30px;"><div class="text-blanner-1">Manipulation algorithms. How Russian Propaganda Spreads on Facebook</div><div class="text-blanner-2">Investigation</div></div></a></div>

<div class="banner hideinit just_ru"><a href="/russian-propaganda-on-facebook" class="banner-wrapper2 w-inline-block" style="padding:30px;"><div class="left-column"><img src="/projects/most/images/propaganda1/manipulation-algorithms-ru.png" loading="lazy" alt=""></div><div class="right-column" style="padding: 30px;"><div class="text-blanner-1">Manipulation algorithms. How Russian Propaganda Spreads on Facebook</div><div class="text-blanner-2">Investigation</div></div></a></div>

<div class="banner"><a href="/openletter/1" class="banner-wrapper w-inline-block"><div class="left-column"><img src="/projects/most/images/russian-dissident-3.jpg" loading="lazy" alt=""></div><div class="right-column" style="padding: 30px;"><div class="text-blanner-1">Open Letter to President Donald J. Trump, Members of Congress, and the American People</div><div class="text-blanner-2">Special project</div></div></a></div>

</div>

<!--noindex-->

<div class="modal fade" id="editcomment" tabindex="-1" role="dialog" aria-labelledby="editcommentLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><!--nottranslate--><span class="nottranslate">&times;</span><!--nottranslate--></span></button>
		<h4 class="modal-title qwerty" id="editcommentLabel">Edit comment</h4>
	  </div>
	  <div class="modal-body">
<input type="hidden" id="editcommentid" name="editcommentid">
<textarea id="commenteditor"></textarea>
	  </div>
      <div class="modal-footer" style="white-space: nowrap;">
		<div style="white-space: nowrap;">
			<button type="button" class="btn btn-default" id="cancelsave" onclick="$('#editcomment').modal('hide');">Cancel</button>
			<button type="button" class="btn btn-primary" id="savecommentbutton" onclick="$('#editcomment').modal('hide'); savecomment(0,-1);">Save comment</button>
		</div>
      </div>
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
					<div class="btn btn-primary btn-sm">
						<input type="file" id="PhotoFile" name="PhotoFile" onchange="showeditphoto();">
						<input class="form-control" type="hidden" id="photo_b64" name="photo_b64">
					</div>
					<div class="input-group" style="margin-top: 10px;">
						<span>Description or keywords:</span><small style="float: right;">No more than 50 characters</small>
						<input type="text" class="form-control" name="description" id="description" value="">
					</div>
					<div id="loadingphoto" style="display: none;"><img src="./images/loading.gif" width="50" height="50"/></div>
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

<div class="trnsltphrss">
<span>Error</span>
<span>Hidden comments are available only to the author of the publication and you.</span>
<span>Hidden comment</span>
<span>Save changes</span>
<span>Insert image</span>
<span>Upload image</span>
<span>Like!</span>
<span>Dislike!</span>
<span>Sorry, there was some error with the request. Please refresh the page.</span>
<span>Save comment</span>
<span>The minimum length of the comment - 5 characters.</span>
<span>Please pay attention!</span>
<span>Are you sure you want to delete this comment?</span>
<span>Delete comment</span>
<span>Link to comment</span>
<span>Highlight and copy this link:</span>
<span>Report abuse</span>
<span>A description of the problem or the essence of the claims:</span>
<span>If you believe that this page violates the rules of our service, let us know!</span>
<span>User:</span>
<span>Comment #</span>
<span>Delete all comments</span>
<span>Please describe the essence of the claims</span>
<span>Ban user</span>
<span>Unblock user</span>
<span>Are you sure you want to block this user?</span>
<span>Are you sure you want to unblock this user?</span>
<span>After that:</span>
<span>Access to this community will be completely closed for</span>
<span>You can unlock the user later in the settings of your community.</span>
<span>All publications and comments made by this user in your community will also be deleted.</span>
<span>Number of reads to end</span>
<span>Number of views</span>
</div>
<!--/noindex-->
<script>
$(document).ready(function(){
edited = false;
gocomment = window.location.hash;
if ('{$community_type}' == '1')
{
	document.getElementById('buybutton').style.display = 'block';
	document.getElementById('buybuttonhead').style.display = 'block';
}
if(gocomment.indexOf('#_') + 1)
{
	gocomment = '';
	window.location.hash = '';
	history.replaceState({foo: 'bar'}, document.title, '/3');
}
loadingcomments = 0;
lastcommentedit = 0;
getcomments();
window.onscroll = showcomments;
thispageurl = '{$thispageurl}';
thispagetitle = '{$post[title]}';
thispageimage = '{$post[ogimage]}';
thispagedescr = '{$post[description]}';
$('[data-toggle="tooltip"]').tooltip();
$(".js-smartPhoto").SmartPhoto();
getshared();
});
</script>
