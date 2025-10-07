<script src="/js/jquery.raty.min.js"></script>
<script>
function js_translate(str) {
if (str == '{$phraseclose}') { str = '{$btn_close}'; }
if (str == 'Close') { str = '{$btn_close}'; }
if (str == '{$phraseok}') { str = '{$btn_ok}'; }
if (str == '{$phrasecancel}') { str = '{$btn_cancel}'; }
if (str == '{$phraseyes}') { str = '{$btn_yes}'; }
if (str == '{$phraseno}') { str = '{$btn_no}'; }
return str;
}
function cleanfilter() {
	var cclist = document.querySelector('#cclist');
	cclist.selectedIndex = 0;
	document.getElementById('memberregion').value = '';
	document.getElementById('memberregion_lng').value = '';
	document.getElementById('membersearch').value = '';
	changetype();
}
function getposts() {
	loadingposts = 1;
	document.getElementById('loadingposts').style.display = 'block';
	$.ajax({
		url: './getposts.php',
		type: 'GET',
		async: true,
		data: {community: '{$community}', publishtime: publishtime, attached: attached, blogcatid: '{$blog_cat_id}', blogtag: '{$blog_tag}', blogdate: '{$blog_date}', blogsearch: '{$blog_search}', byuid: {$byuid}, posttype: '0,1'},
		success: function(response) {
			$('.endposts').remove();
			if (publishtime == 0)
			{
				$('#postsblock').html(response);
			}
			else
			{
				$('#postsblock').append(response);
			}
			document.getElementById('loadingposts').style.display = 'none';
			$('[data-toggle="tooltip"]').tooltip();
			loadingposts = 0;
			if(typeof RePositions == 'function') {
				RePositions();
			}
		},
		error: function(response) {
			document.getElementById('loadingposts').style.display = 'none';
			loadingposts = 0;
			console.log('Can\'t load records!');
		},
		timeout: 10000
	});
}
function showposts() {
	if (loadingposts == 0)
	{
		for(var i=0;i<$('.endposts').get().length;i++)
		{
			var item = document.getElementsByClassName('endposts');
			var itemFirst = item[i];
			if (elementInViewport(itemFirst) || publishtime == 0)
			{
				getposts();
			}
		}
	}
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
function searchblog() {
	if ({$user_id} == 0)
	{
		quickreg();
		return;
	}
	var searchstr = document.getElementById('blogsearch').value;
	if (searchstr == '')
	{
		location.href='{$addpath}{$blogpath}';
	}
	else
	{
		location.href='{$addpath}/search/'+searchstr;
	}
}
jQuery(document).ready(function() {
	loadingposts = 0;
	publishtime = 0;
	attached = 1;
	lasteventtime = 0;
	getposts();
	window.onscroll = showposts;
});
</script>
{$categorybanner}
{$blogsearchhtml}
				<span class="endposts" style="width:100%;display:block;"><button class="btn btn-default" onclick="getposts()">Show more...</button></span>
				<div id="postsblock" style="width:100%;display:block;">
				</div>
				<div id="loadingposts" style="display:none;text-align: center;margin:0 auto;width:100%;"><br /><br /><span>Loading...</span><br /><img src="/images/loading.gif" alt="Loading..." width="30" style="margin:0 auto;"><br /><br /></div>
<div style="width: 100%; padding: 10px;display:none;" id="typesdiv">
<a href="{$addpathlng}{$addpath}">To publications</a>
<h2 style="margin-top:5px;">Subscribers:</h2>
<span style="position: absolute; right: 30px; margin-top: -30px;"><a href="javascript:void(0)" onclick="cleanfilter()" style="color: #6699cc; border-bottom: 1px dashed #6699cc;">clean the filter</a></span>
<div class="form-inline" style="margin-top: -10px;">
<div class="input-group" style="margin-top: 10px;">
<span class="input-group-addon">Country:</span>
{$cc_html}
</div>
<div class="input-group" style="margin-top: 10px;display:none;" id="citydiv">
<span class="input-group-addon">City:</span>
    <div class="typeahead__container" style="font-size: 12pt;">
        <div class="typeahead__field" style="font-size: 12pt;">
            <span class="typeahead__query" style="font-size: 12pt;">
				<input type="text" class="form-control cities" name="memberregion_lng" id="memberregion_lng" value="" placeholder="City search..." autocomplete="off" onchange="checkregion()">
			</span>
        </div>
    </div>
	<input type="hidden" name="memberregion" id="memberregion" value="">
</div>
</div>
<div class="input-group" style="margin-top: 10px;">
	<span class="input-group-addon"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></span>
	<input type="search" class="form-control" name="membersearch" id="membersearch" placeholder="Search Members"><span class="input-group-addon" onclick="document.getElementById('membersearch').value='';changetype();"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></span>
</div>
</div>
				<span class="endmembers"></span>
				<div id="membersblock" style="width: 100%; text-align: center;">
				</div>
				<div id="loadingmembers" style="display: none;text-align: center;"><span>Loading...</span><br /><img src="/images/loading.gif" alt="Loading..." width="30"><br /><a href="{$thispageurl}">Click here if loading is not performed</a></div>

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
<span>Please rate from 1 to 5 points!</span>
<span>it's disgusting</span>
<span>it's bad</span>
<span>so-so</span>
<span>it's good</span>
<span>it's perfectly</span>
<span>Do not rate</span>
<span>Rate this:</span>
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
<span>User:</span>
<span>Comment #</span>
<span>Delete all comments</span>
<span>Please describe the essence of the claims</span>
<span>The number of views and unique users (when the reader was stayed more than 20 seconds)</span>
<span>Share on Facebook</span>
<span>Share on Twitter</span>
<span>Share on Odnoklassniki</span>
<span>Share on VKontakte</span>
<span>Share on Google Plus</span>
<span>Send via Viber</span>
<span>Send via Telegram</span>
<span>Copy link</span>
<span>Search Members</span>
<span>Are you sure you want to cancel the subscription for the selected user?</span>
</div>
<!--/noindex-->
