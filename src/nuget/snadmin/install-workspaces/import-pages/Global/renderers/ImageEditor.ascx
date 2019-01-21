<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="SenseNet.Portal.Virtualization" %>
<%@ Import Namespace="SenseNet.ContentRepository" %>
<%@ Import Namespace="SenseNet.ContentRepository.Storage" %>
<%@ Import Namespace="SenseNet.ContentRepository.Storage.Data" %>
<%@ Import Namespace="SenseNet.ContentRepository.i18n" %>
<sn:ScriptRequest ID="script3" runat="server" Path="$skin/scripts/jquery/plugins/fileupload/jquery.iframe-transport.js" />
<sn:ScriptRequest ID="script4" runat="server" Path="$skin/scripts/jquery/plugins/fileupload/jquery.fileupload.js" />
<sn:ScriptRequest ID="Scriptrequest2" runat="server" Path="$skin/scripts/kendoui/kendo.web.min.js" />
<sn:ScriptRequest ID="ScriptRequest1" runat="server" Path="$skin/scripts/sn/SN.ImageEditor.js" />
<sn:ScriptRequest ID="Scriptrequest3" runat="server" Path="$skin/scripts/plugins/excanvas.compiled.js" />
<sn:ScriptRequest ID="Scriptrequest4" runat="server" Path="$skin/scripts/jquery/plugins/jquery.Jcrop.min.js" />
<sn:CssRequest ID="CssRequest" runat="server" CSSPath="$skin/styles/kendoui/kendo.common.min.css" />
<sn:CssRequest ID="CssRequest1" runat="server" CSSPath="$skin/styles/kendoui/kendo.metro.min.css" />
<sn:CssRequest ID="CssRequest2" runat="server" CSSPath="$skin/styles/SN.ImageEditor.css" />
<sn:CssRequest ID="CssRequest3" runat="server" CSSPath="$skin/styles/jquery.Jcrop.min.css" />
<sn:CssRequest ID="CssRequest4" runat="server" CSSPath="$skin/styles/SN.Overlay.css" />
<style>
    .sn-upload-header {
        margin-bottom: 10px;
        display: inline-block;
        vertical-align: middle;
        width: 80%;
    }

    .sn-upload-filetitle {
        float: left;
    }

    .sn-upload-fileprogress {
        margin-top: 10px;
        border: 1px solid #DDD;
        padding: 10px;
    }

    .sn-upload-progress {
        position: relative;
        margin-top: 10px;
    }

    .sn-upload-progressbar {
        background-color: #EEE;
    }

    .sn-upload-bar {
        height: 5px;
        background-color: #BBB;
    }

    .sn-upload-uploadedbar {
        background-color: #6C4;
    }

    .sn-upload-button {
        font-size: 1em;
        margin-right: 5px;
        display: inline;
    }

    .sn-upload-error {
        color: #F00;
        font-weight: bold;
        display: none;
    }

    .sn-upload-buttonbar {
        overflow: hidden;
    }

    #sn-upload-fileuploadbutton {
        position: relative;
        overflow: hidden;
        float: left;
    }

    #sn-upload-fileupload {
        position: absolute;
        top: 0;
        right: 0;
        margin: 0;
        font-size: 23px;
        direction: ltr;
        cursor: pointer;
        transform: translate(-300px, 0) scale(4);
        opacity: 0;
        filter: alpha(opacity=0);
    }

    #sn-upload-startbutton {
        cursor: pointer;
    }

    .sn-upload-cancelfile {
        display: inline-block;
        cursor: pointer;
        text-align: right;
        width: 5%;
    }

    .sn-upload-clear {
        clear: both;
    }

    .sn-upload-type {
        line-height: 25px;
    }

    .sn-upload-draganddrop {
        text-align: center;
        color: #ccc;
        font-size: 18px;
        padding: 10px;
    }

        .sn-upload-draganddrop:before {
            content: '\e0a7';
            font-family: icon;
            display: block;
            font-size: 180%;
        }

    .sn-upload-area {
        border: dotted 2px #ccc;
        padding: 10px;
    }

        .sn-upload-area.active {
            opacity: 0.5;
        }

            .sn-upload-area.active .sn-upload-draganddrop {
                color: #007dc2;
            }

    .sn-buttons .sn-submit {
        margin-right: 0;
    }

    #progress {
        margin-top: 20px;
    }

    .sn-upload-header {
        margin-bottom: 10px;
    }

    .sn-upload-filetitle {
        float: left;
    }

    .sn-upload-fileprogress {
        margin-top: 10px;
        border: 1px solid #DDD;
        padding: 10px;
    }

    .sn-upload-progress {
        position: relative;
        margin-top: 10px;
    }

    .sn-upload-progressbar {
        background-color: #EEE;
    }
    .prev {
        width: 100px;
        max-height: 100px;
        text-align: center;
        vertical-align: middle;
        
margin-right: 20px;
                
display: inline-block;
    }
    .prev-img {
        max-width: 100px;max-height: 100px;

    }
    .edit-name {
        width: 16px;
        height: 16px;
        display: inline-block;
        vertical-align: middle;
        cursor: pointer;
        background: url(/Root/Global/images/icons/16/edit.png);
        margin-left: 5px;
    }
    .name {
        display: inline-block;
        vertical-align: middle;
    }
    .save-name {
       background: url(/Root/Global/images/icons/16/tick.png);
       width: 16px;
        height: 16px;
        display: inline-block;
        vertical-align: middle;
        cursor: pointer;
        margin-left: 5px;
    }
</style>

<%
    var currentContentPath = SenseNet.Portal.Virtualization.PortalContext.Current.ContextNodePath;
    var canSave = PortalContext.Current.ContextNode.Security.HasPermission(SenseNet.ContentRepository.User.Current, SenseNet.ContentRepository.Storage.Security.PermissionType.Save);
%>

<div class="sn-upload-area">
    <div class="sn-upload-buttonbar">
        <div id="sn-upload-fileuploadbutton" class="sn-submit sn-notdisabled sn-upload-button">
            <span>
                <%= SenseNetResourceManager.Current.GetString("Action", "UploadAddFile")%></span>
            <input id="sn-upload-fileupload" type="file" name="files[]" data-url="/OData.svc<%= PortalContext.Current.ContextNode.ParentPath %>('<%= PortalContext.Current.ContextNode.Name %>')/Upload" />
        </div>
        <div style="clear: both;">
        </div>
    </div>
    <div class="sn-upload-draganddrop">
        <%= SenseNetResourceManager.Current.GetString("Action", "UploadDragAndDropOneFile")%>
    </div>
    <div class="sn-panel sn-buttons sn-upload-buttons">
        <div id="sn-upload-startbutton" class="sn-submit sn-notdisabled sn-upload-button sn-submit-disabled">
            <span><%= SenseNetResourceManager.Current.GetString("Action", "UploadStartUpload")%></span>
        </div>
        <sn:BackButton CssClass="sn-submit" runat="server" id="BackButton2" Text="<%$ Resources:Action,Close %>" />
    </div>
</div>
<div id="imageEditor"></div>

<script>
    $(function () {
        var maxChunkSize = '<%= SenseNet.Configuration.BlobStorage.BinaryChunkSize %>';
        var currentContent = '<%=currentContentPath%>';
        var uploadEnabled = '<% PortalContext.Current.ContextNode.Security.HasPermission(SenseNet.ContentRepository.User.Current, SenseNet.ContentRepository.Storage.Security.PermissionType.Save);%>';

        var isAdmin = <%= canSave ? "true" : "false" %>;
        if (supportedBrowser()) {

            $editor = $('#imageEditor').parent();




            function uploadImage(url, uploaddata, img_b64, imgName){
                editor.destroy();
                if (uploaddata[0].files.length > 0 && $('#progress').length === 0) {
                    $progress = $('<div id="progress"></div>');
                    $('.sn-upload-draganddrop').before($progress);
                }

                //var defaultFileName = 'image.png';
                var filename = uploaddata[0].files[uploaddata[0].files.length - 1].name;
                if (typeof filename === 'undefined')
                    filename = imgName;

                // first request creates the file
                //var filename = defaultFileName, filetype = fileType;

                var filelength = uploaddata[0].files[uploaddata[0].files.length - 1].size;

                $row = $('<div class="uploadrow sn-upload-fileprogress"></div>');

                $row.html('<div class="prev"><img class="prev-img" src="' + img_b64 + '" /></div><div class="sn-upload-header"><span class="name"><span>' + filename + '</span><input type="text" style="display: none" /></span></div><div class="sn-upload-cancelfile"><img src="/Root/Global/images/icons/16/delete.png"></div>');

                $progress.append($row);

                function isUniqueFileName(filename, idx) {
                    for (var i = 0; i < uploaddata.length; i++) {
                        if (i == idx)
                            continue;
                        if (uploaddata[i].files[0].name == filename)
                            return false;
                    }
                    return true;
                }

                $('.sn-upload-cancelfile').on('click', function(){
                    var that = $(this);
                    $crow = that.closest('.sn-upload-fileprogress');
                    var index = $crow.index();
                    $crow.remove();
                    uploaddata[0].files.splice(index, 1);
                });

                $('.editor').on('click', function(){
                    var that = $(this);
                    $crow = that.closest('.sn-upload-fileprogress');
                    var index = $crow.index();
                    $name = that.prev('.name').children('span');
                    $input = $name.siblings('input');
                    if(!that.hasClass('save-name')){
                        $input.val($name.text()).show();
                        $name.text('');
                        that.addClass('save-name');
                    }
                    else{
                        var newname = $input.val();
                        $name.text(newname);
                        $input.hide();
                        uploaddata[0].files[index].name = newname;
                        that.removeClass('save-name');
                    }
                });

                $submitUpload = $('#sn-upload-startbutton');
                $submitUpload.removeClass('sn-submit-disabled');

                $submitUpload.on('click', function(){
                    var url = $('#sn-upload-fileupload').attr('data-url');

                    
                    for (var i = 0; i < uploaddata.length; i++) {
                        (function () {
                            var idx = i;
                            var currentData = uploaddata[idx];
                            // first request creates the file
                            //var filename = defaultFileName, filetype = fileType;

                            var filelength = currentData.files[0].size;

                            if (!isUniqueFileName(filename, idx))
                                currentOverwrite = false;
                            else
                                currentOverwrite = true;

                            $.ajax({
                                url: url + '?create=1',
                                type: 'POST',

                                data: {
                                    "ContentType": 'Image',
                                    "FileName": filename,
                                    "Overwrite": currentOverwrite,
                                    "UseChunk": filelength > maxChunkSize,
                                    "PropertyName": "Binary"
                                },
                                success: function (data) {
                                    // set formdata and submit upload request
                                    currentData.formData = {
                                        "FileName": filename,
                                        "Overwrite": currentOverwrite,
                                        "ContentType": 'Image',
                                        "ChunkToken": data,
                                        "PropertyName": "Binary"
                                    };
                                    currentData.submit();
                                },
                                error: function (data) {
                                    var $error = $('.sn-upload-error', currentData.context);
                                    if (typeof (data) == 'undefined') {
                                        $error.text($('#sn-upload-othererror').text());
                                    } else {
                                        var result = jQuery.parseJSON(data.responseText);
                                        $error.text(result.error.message.value);
                                    }
                                    $error.show();
                                }
                            });
                        })();
                    }


                    $('#sn-upload-startbutton').addClass('sn-submit-disabled');
                });
               
            }

            
            
            editor = $('#imageEditor').imageEditor({
                uploadArea: $('.sn-upload-area'),
                menuitems: ['download', 'upload','resize', 'filter', 'undo', 'redo'],
                command: ['crop', 'rotate-left', 'rotate-right'/*,'flip-horizontal','flip-vertical', 'text'*/, 'color-picker', 'forecolor'],
                cropRatioX: 150,
                cropRatioY: 80,
                contentType: 'Image',
                maxStepCount: 10,
                targetPath: currentContent,
                maxImageWidth: 1024,
                maxImageHeight: 768,
                uploadPermissionAllowed: isAdmin,
                backToLibraryLink: true,
                uploadFunction: uploadImage
            }).data("snImageEditor");
        }
        else {
            var uploaddata = [];
            var maxChunkSize = <%= SenseNet.Configuration.BlobStorage.BinaryChunkSize %>;
            
            var unSupportedBrowserButtons = '<div class="sn-panel sn-buttons sn-upload-buttons">\
                                        <div id="sn-upload-startbutton" class="sn-submit sn-notdisabled sn-upload-button sn-submit-disabled">\
                                         <span><%= SenseNetResourceManager.Current.GetString("Action", "UploadStartUpload")%></span>\
                                        </div>\
                                        <sn:BackButton CssClass="sn-submit" runat="server" id="BackButton" Text="<%$ Resources:Action,Close %>" />\
                                        </div>';
            var progressTemplate = '<div id="progress"></div>\
                                    <span id="sn-upload-othererror" style="display:none;"><%= SenseNetResourceManager.Current.GetString("Action", "UploadOtherError")%></span>';

            $('.sn-upload-buttonbar').after(progressTemplate);
            $('.sn-upload-area').append(unSupportedBrowserButtons);

            // 1 MB: 1048576
            //10 MB: 10485760
            //50 MB: 52428800

            // ios will always use 'image.jpg' filename, that would cause problems with simultaneous multiple file uploads.
            // therefore from ios we always create new files in the repository. otherwise we always overwrite
            var iosregex = "^(?:(?:(?:Mozilla/\\d\\.\\d\\s*\\()+|Mobile\\s*Safari\\s*\\d+\\.\\d+(\\.\\d+)?\\s*)(?:iPhone(?:\\s+Simulator)?|iPad|iPod);\\s*(?:U;\\s*)?(?:[a-z]+(?:-[a-z]+)?;\\s*)?CPU\\s*(?:iPhone\\s*)?(?:OS\\s*\\d+_\\d+(?:_\\d+)?\\s*)?(?:like|comme)\\s*Mac\\s*O?S?\\s*X(?:;\\s*[a-z]+(?:-[a-z]+)?)?\\)\\s*)?(?:AppleWebKit/\\d+(?:\\.\\d+(?:\\.\\d+)?|\\s*\\+)?\\s*)?(?:\\(KHTML,\\s*(?:like|comme)\\s*Gecko\\s*\\)\\s*)?(?:Version/\\d+\\.\\d+(?:\\.\\d+)?\\s*)?(?:Mobile/\\w+\\s*)?(?:Safari/\\d+\\.\\d+(\\.\\d+)?.*)?$";
            var isios = new RegExp(iosregex).test(navigator.userAgent);
            var overwrite = !isios;

            function isUniqueFileName(filename, idx) {
                for (var i = 0; i < uploaddata.length; i++) {
                    if (i == idx)
                        continue;
                    if (uploaddata[i].files[0].name == filename)
                        return false;
                }
                return true;
            }

            function cancelFile(data) {
                // abort requests
                if (data.jqXHR)
                    data.jqXHR.abort();

                // remove from uploaddata
                var idx = uploaddata.indexOf(data);
                if (idx != -1)
                    uploaddata.splice(idx, 1);

                // remove from dom
                data.context.remove();

                if (uploaddata.length == 0)
                    $('#sn-upload-startbutton').addClass('sn-submit-disabled');
            }

            $(document).on('click', '#sn-upload-startbutton', function (e) {
                var url = $('#sn-upload-fileupload').attr('data-url');

                var contentType = 'Image';
                for (var i = 0; i < uploaddata.length; i++) {
                    (function () {
                        var idx = i;
                        var currentData = uploaddata[idx];

                        // first request creates the file
                        var filename, filetype;
                        if ($.browser.msie && parseInt($.browser.version, 10) > 6 && parseInt($.browser.version, 10) < 10) {
                            filetype = currentData.files[0].name.split('\\')
                            filetype = filetype[filetype.length - 1];
                        }
                        else
                            filetype = currentData.files[0].type.split('/')[1];
                        if (filetype === 'jpeg')
                            filetype === 'jpg';
                        if (currentData.files[0].name && currentData.files[0].name.length > 0) {
                            filename = currentData.files[0].name;
                        }
                        else {
                            filename = 'image' + (i + 1) + '.' + filetype;
                        }

                        var filelength = currentData.files[0].size;
                        var currentOverwrite = overwrite;

                        // if two or more files of the same name have been selected to upload at once, we switch off overwrite for these files
                        if (!isUniqueFileName(filename, idx))
                            currentOverwrite = false;


                        $.ajax({
                            url: url + '?create=1',
                            type: 'POST',

                            data: {
                                "ContentType": contentType,
                                "FileName": filename,
                                "Overwrite": currentOverwrite,
                                "UseChunk": filelength > maxChunkSize,
                                "PropertyName": "Binary"
                            },
                            success: function (data) {
                                // set formdata and submit upload request
                                currentData.formData = {
                                    "FileName": filename,
                                    "Overwrite": currentOverwrite,
                                    "ContentType": contentType,
                                    "ChunkToken": data,
                                    "PropertyName": "Binary"
                                };
                                currentData.submit();
                            },
                            error: function (data) {
                                var $error = $('.sn-upload-error', currentData.context);
                                if (typeof (data) == 'undefined') {
                                    $error.text($('#sn-upload-othererror').text());
                                } else {
                                    var result = jQuery.parseJSON(data.responseText);
                                    $error.text(result.error.message.value);
                                }
                                $error.show();
                            }
                        });
                    })();
                }
                uploaddata = [];
                $('#sn-upload-startbutton').addClass('sn-submit-disabled');
            });
            var count = 0;
            $(function () {
                $('#sn-upload-fileupload').fileupload({
                    maxChunkSize: maxChunkSize,
                    dataType: 'json',
                    progress: function (e, data) {
                        var progress = parseInt(data.loaded / data.total * 100, 10);
                        progress = progress > 100 ? 100 : progress;
                        $('.sn-upload-bar', data.context).css('width', progress + '%');
                    },
                    add: function (e, data) {
                        count += 1;
                        var filename, filetype;
                        if (data.files[0].name && data.files[0].name.length > 0) {
                            if ($.browser.msie && parseInt($.browser.version, 10) > 6 && parseInt($.browser.version, 10) < 10) {
                                var inputValue = data.fileInput[0].value.split('\\');
                                filename = inputValue[inputValue.length - 1];
                            }
                            else {
                                filetype = data.files[0].type.split('/')[1];
                                filename = data.files[0].name;
                            }
                        }
                        else {
                            filetype = data.files[0].type.split('/')[1];
                            filename = 'image' + count + '.' + filetype;
                        }
                        var title = '<div class="sn-upload-header"><div class="sn-upload-filetitle">' + filename + '</div><div class="sn-upload-cancelfile"><img src="/Root/Global/images/icons/16/delete.png"></div><div class="sn-upload-clear"></div></div>';
                        var error = '<div class="sn-upload-error"></div>';
                        var progress = '<div class="sn-upload-progressbar"><div class="sn-upload-bar" style="width: 0%;"></div></div>';
                        data.context = $('<div class="sn-upload-fileprogress">' + title + error + '<div class="sn-upload-progress">' + progress + '</div></div>').appendTo($('#progress'));
                        uploaddata.push(data);

                        $('#sn-upload-startbutton').removeClass('sn-submit-disabled');

                        $('.sn-upload-cancelfile', data.context).on('click', function () { cancelFile(data); });
                        //data.submit();
                    },
                    fail: function (e, data) {
                        var $error = $('.sn-upload-error', data.context);
                        var json = (data.jqXHR.responseText) ? jQuery.parseJSON(data.jqXHR.responseText) : data.result;
                        if (typeof (json) == 'undefined') {
                            $error.text($('#sn-upload-othererror').text());
                        } else {
                            $error.text(json.error.message.value);
                        }
                        $error.show();
                    },
                    done: function (e, data) {
                        var json = (data.jqXHR.responseText) ? jQuery.parseJSON(data.jqXHR.responseText) : data.result;
                        $('.sn-upload-bar', data.context).addClass('sn-upload-uploadedbar');

                        var filename = json.Name;
                        var url = json.Url;
                        $('.sn-upload-filetitle', data.context).html('<a href="' + url + '">' + filename + '</a>');
                    }
                });
            });
        }

        function supportedBrowser(){
            var isSupported = false;
            if (navigator.userAgent.search("MSIE") >= 0){
                var position = navigator.userAgent.search("MSIE") + 5;
                var end = navigator.userAgent.search("; Windows");
                var version = navigator.userAgent.substring(position,end);
                if(version < 10){
                    isSupported = false;
                }
                else {
                    isSupported = true;
                }
            }
            else if(!!navigator.userAgent.match(/Trident.*rv[ :]*11\./)){
                isSupported = true;
            }
            else if (navigator.userAgent.search("Chrome") >= 0){
                var position = navigator.userAgent.search("Chrome") + 7;
                var end = navigator.userAgent.search(" Safari");
                var version = navigator.userAgent.substring(position,end);
                isSupported = true;
            }
            else if (navigator.userAgent.search("Firefox") >= 0){
                var position = navigator.userAgent.search("Firefox") + 8;
                var version = navigator.userAgent.substring(position);
                isSupported = true;
            }
            else if (navigator.userAgent.search("Safari") >= 0 && navigator.userAgent.search("Chrome") < 0){//<< Here
                var position = navigator.userAgent.search("Version") + 8;
                var end = navigator.userAgent.search(" Safari");
                var version = navigator.userAgent.substring(position,end);
                isSupported = false;
            }
            else if (navigator.userAgent.search("Opera") >= 0){
                var position = navigator.userAgent.search("Version") + 8;
                var version = navigator.userAgent.substring(position);
                isSupported = true;
            }
            else{
                //document.write('"Other"');
            }

            return isSupported;

        }

    });
</script>
