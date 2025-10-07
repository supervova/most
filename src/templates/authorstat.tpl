<div style="width:100%">
<h1>Statistics of interest in publications</h1>
<h4>Statistics for the period:</h4>
<div class="form-inline">
<div class="input-group" data-link-field="dtp_input1">
	<input id="fromtime" class="form-control" size="10" type="date" value="{$today_date}" placeholder="Click to select" onchange="getstat()" style="min-width:150px;">
</div> - 
<div class="input-group" data-link-field="dtp_input2">
	<input id="totime" class="form-control" size="10" type="date" value="{$today_date}" placeholder="Click to select" onchange="getstat()" style="min-width:150px;">
</div>
</div>
<small style="margin-left: 10px;">Your time zone:</small> {$user_utc_str} <small>(<a href="{$profile_href}" target="_blank">profile settings</a>)</small>
<input type="hidden" id="dtp_input1" value="" />
<input type="hidden" id="dtp_input2" value="" />
<div class="table-responsive">
<table>
<thead>
<tr>
<td style="padding:5px;"><strong>Publications</strong></td><td style="padding:5px;"><strong>Visitors</strong></td><td style="padding:5px;"><strong>Readed</strong></td><td style="padding:5px;"><strong>Earned</strong></td>
</tr>
</thead>
<tbody id="tbody">
{$tbody}
</tbody>
</table>
</div>
<p>{$finance_html}</p>
</div>


<div class="trnsltphrss">
<span>Click to select</span>
</div>

<script>
$(document).ready(function(){
	getstat();
});
function getstat() {
    var fromtime = document.getElementById("fromtime").value;
    var totime = document.getElementById("totime").value;
	if (fromtime == '' || totime == '')
	{
		return;
	}
	const request = new XMLHttpRequest();
	const url = "./authorstat.php";
	const params = "from=" + fromtime+ "&to=" + totime;
	request.open("POST", url, true);
	request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	request.addEventListener("readystatechange", () => {
		if(request.readyState === 4 && request.status === 200) {
			document.getElementById("tbody").innerHTML = request.responseText;
		}
	});
	request.send(params);
}
</script>
