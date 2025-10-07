<script>
function showthisavatar() {
	var image = $("#PhotoFile");
	if (image[0].files && image[0].files[0]) {
		resizeFile(image[0].files[0], $('#thisavatar'), $('#photo_b64'))
	}
}
function resizeFile(file, thisavatar, b64field) {
	newavatar = 1;
	$('#p_prldr').show();
	var reader = new FileReader();
    reader.onloadend = function () {
        var tempImg = new Image();
        tempImg.src = reader.result;
        tempImg.onload = function () {
            var tempW = tempImg.width;
            var tempH = tempImg.height;
            imgcrop(this, tempW, tempH, 512, 512, b64field);
            $(thisavatar).attr('src', $(b64field).val());
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
function saveauthor(authorid) {
	$('#p_prldr').show();
	var authorid = document.getElementById('authorid').value;
	var photo_b64 = document.getElementById('photo_b64').value;
	var bioen = document.getElementById('bioen').value;
	var fullname = document.getElementById('fullname').value;
	var linkedemail = document.getElementById('linkedemail').value;
	var isenabled = 0;
	var isdeleted = 0;
	if (document.getElementById('isenabled').checked) {
		var isenabled = 1;
	}
	if (document.getElementById('isdeleted').checked) {
		var isdeleted = 1;
	}
	if (fullname.trim() === "")
	{
		alert('Fill out the form data!');
		return;
	}
	$.ajax({
		url: './saveauthor.php',
		type: 'POST',
		data: { authorid: authorid, photo_b64: photo_b64, bioen: bioen, fullname: fullname, linkedemail: linkedemail, isenabled: isenabled, isdeleted: isdeleted, newavatar: newavatar },
		success: function(response) {
			response = $.parseJSON(response);
			if (response[0] == 'OK')
			{
				$('#p_prldr').show();
				location.reload();
			}
			else
			{
				$('#p_prldr').delay(100).fadeOut('slow');
				alert(response[0]);
			}
		},
		error: function(jqXHR, exception){
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
		  alert(msg);
		  location.reload();
		}
	});
}
function editauthor(authorid) {
 	// Установка значений по умолчанию
	$("#isenabled").prop("checked", true);
	$("#isdeleted").prop("checked", false);
	$("#authorid").val("0");
	$("#linkedemail").val("");
	$("#bioen").val("");
	$("#fullname").val("");
	$("#thisavatar").attr("src", "{$defaultavatar}");

    if (authorid > 0) {
		$.ajax({
			url: './getauthor.php',
			type: 'POST',
			data: { authorid: authorid },
			success: function(response) {
				response = $.parseJSON(response);
				if (response[0] == 'OK')
				{
				    $("#editauthor").appendTo("body").modal('show');
					$("#authorid").val(response[1].id);
					$("#isenabled").prop("checked", response[1].enabled == 1);
					$("#isdeleted").prop("checked", response[1].deleted == 1);
					$("#bioen").val(response[1].bioen);
					$("#linkedemail").val(response[1].linkedemail);
					$("#fullname").val(response[1].fullname);
					if (response[1].avatar && response[1].avatar.trim() !== "") {
						$("#thisavatar").attr("src", response[1].avatar);
					} else {
						$("#thisavatar").attr("src", "{$defaultavatar}");
					}
				}
				else
				{
					alert(response[0]);
				}
			}
		});
    }
	else
	{
		$("#editauthor").appendTo("body").modal('show');
		$("#authorid").val(0);
		$("#isenabled").prop("checked", 1);
		$("#isdeleted").prop("checked", 0);
		$("#bioen").val('');
		$("#linkedemail").val('');
		$("#fullname").val('');
		$("#thisavatar").attr("src", "{$defaultavatar}");
	}
}
newavatar = 0;
</script>

<div id="editauthor" class="modal fade">
  <div class="modal-dialog">
	<div class="modal-content">
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h4 class="modal-title">Author's card</h4>
	  </div>
	  <form class="form-vertical" action="javascript:void(0);">
	  <input type="hidden" name="authorid" id="authorid" value="0">
	  <div style="padding: 10px 10px 10px;">
				<div class="file-field">
					<div style="vertical-align: middle; margin: 2px; white-space: nowrap; width: 100%;">
					<img id="thisavatar" src="{$defaultavatar}" style="width: 100%; max-width: 200px;height: autho;">
					</div>
					<div id="selectfile" class="btn btn-primary btn-sm" style="display: inline-block;">
						<input type="file" id="PhotoFile" name="PhotoFile" onchange="showthisavatar();"> 
						<input class="form-control" type="hidden" id="photo_b64" name="photo_b64">
					</div>
					<div style="margin-top: 5px;">
						<span>Full name:</span>
						<input type="text" class="form-control" name="fullname" id="fullname" value="" style="width:100%">
					</div>
					<div style="margin-top: 5px;">
						<span>Role:</span><small style="float: right;font-weight: 600">Must be in English!</small>
						<input type="text" class="form-control" name="bioen" id="bioen" value="" style="width:100%">
					</div>
					<div style="margin-top: 5px;">
						<span>Associated user (email):</span><small style="float: right;font-weight: 600">Must be in English!</small>
						<input type="text" class="form-control" name="linkedemail" id="linkedemail" value="" style="width:100%">
					</div>
				</div>
	  </div>
	  <div class="modal-footer">
			<div style="width:100%">
			<div class="checkbox" style="display:inline-block;padding-right:20px;">
			<label><input type="checkbox" name="isenabled" id="isenabled"> <span style="color:green;">Show author</span>
			</label>
			</div>
			<div id="deletediv" class="checkbox has-error" style="display:inline-block;">
			<label><input type="checkbox" name="isdeleted" id="isdeleted"> Delete author
			</label>
			</div>
			</div>
			<div style="display: inline-block; white-space: nowrap;">
			<button id="cancelimgbutton" type="button" class="btn btn-default" data-dismiss="modal">Cancel changes</button>
			<button id="saveimgbutton" type="button" class="btn btn-primary" onclick="saveauthor()">Save changes</button>
		</div>
	  </div>
	  </form>
	</div>
  </div>
</div>
