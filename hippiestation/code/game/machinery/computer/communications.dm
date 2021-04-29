/obj/machinery/computer/communications/proc/get_javascript_header(form_id)
	var/dat = {"<script type="text/javascript">
						function getLength(){
							var reasonField = document.getElementById('reasonfield');
							if(reasonField.value.length >= [CALL_SHUTTLE_REASON_LENGTH]){
								if(reasonField.value.length <= [MAX_CALL_SHUTTLE_REASON_LENGTH]){
									reasonField.style.backgroundColor = "#DDFFDD";
									}
								else {
									reasonField.style.backgroundColor = "#FFDDDD";
								}
							}
							else {
								reasonField.style.backgroundColor = "#FFDDDD";
							}
						}
						function submit() {
							document.getElementById('[form_id]').submit();
						}
					</script>"}
	return dat