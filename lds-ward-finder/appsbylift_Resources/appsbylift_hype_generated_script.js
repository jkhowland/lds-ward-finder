//	HYPE.documents["appsbylift"]

(function HYPE_DocumentLoader() {
	var resourcesFolderName = "appsbylift_Resources";
	var documentName = "appsbylift";
	var documentLoaderFilename = "appsbylift_hype_generated_script.js";

	// find the URL for this script's absolute path and set as the resourceFolderName
	try {
		var scripts = document.getElementsByTagName('script');
		for(var i = 0; i < scripts.length; i++) {
			var scriptSrc = scripts[i].src;
			if(scriptSrc != null && scriptSrc.indexOf(documentLoaderFilename) != -1) {
				resourcesFolderName = scriptSrc.substr(0, scriptSrc.lastIndexOf("/"));
				break;
			}
		}
	} catch(err) {	}

	// load HYPE.js if it hasn't been loaded yet
	if(typeof HYPE == "undefined") {
		if(typeof window.HYPE_DocumentsToLoad == "undefined") {
			window.HYPE_DocumentsToLoad = new Array();
		}
		window.HYPE_DocumentsToLoad.push(HYPE_DocumentLoader);

		var headElement = document.getElementsByTagName('head')[0];
		var scriptElement = document.createElement('script');
		scriptElement.type= 'text/javascript';
		scriptElement.src = resourcesFolderName + '/' + 'HYPE.js';
		headElement.appendChild(scriptElement);
		return;
	}
	
	var attributeTransformerMapping = {"BorderRadiusTopLeft":"PixelValueTransformer","BackgroundColor":"ColorValueTransformer","BorderWidthBottom":"PixelValueTransformer","BoxShadowXOffset":"PixelValueTransformer","WordSpacing":"PixelValueTransformer","Opacity":"FractionalValueTransformer","BorderWidthRight":"PixelValueTransformer","BorderWidthTop":"PixelValueTransformer","BoxShadowColor":"ColorValueTransformer","BorderColorBottom":"ColorValueTransformer","FontSize":"PixelValueTransformer","BorderRadiusTopRight":"PixelValueTransformer","TextColor":"ColorValueTransformer","Rotate":"DegreeValueTransformer","Height":"PixelValueTransformer","BorderColorTop":"ColorValueTransformer","PaddingLeft":"PixelValueTransformer","Top":"PixelValueTransformer","BackgroundGradientStartColor":"ColorValueTransformer","TextShadowXOffset":"PixelValueTransformer","PaddingTop":"PixelValueTransformer","BackgroundGradientAngle":"DegreeValueTransformer","PaddingBottom":"PixelValueTransformer","PaddingRight":"PixelValueTransformer","BorderColorLeft":"ColorValueTransformer","Width":"PixelValueTransformer","TextShadowColor":"ColorValueTransformer","ReflectionOffset":"PixelValueTransformer","Left":"PixelValueTransformer","BorderRadiusBottomRight":"PixelValueTransformer","ReflectionDepth":"FractionalValueTransformer","BoxShadowYOffset":"PixelValueTransformer","BorderColorRight":"ColorValueTransformer","LineHeight":"PixelValueTransformer","BorderWidthLeft":"PixelValueTransformer","TextShadowBlurRadius":"PixelValueTransformer","TextShadowYOffset":"PixelValueTransformer","BorderRadiusBottomLeft":"PixelValueTransformer","BackgroundGradientEndColor":"ColorValueTransformer","BoxShadowBlurRadius":"PixelValueTransformer","LetterSpacing":"PixelValueTransformer"};

var scenes = [{"timelines":{"kTimelineDefaultIdentifier":{"framesPerSecond":30,"animations":[{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":0.73333334922790527,"timingFunction":"easeinout","type":0,"oid":"67882E1F-96C3-4B8D-B548-0BABF5E18EC2-44726-0000246E65591902","startTime":0},{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":0.76666665077209473,"timingFunction":"easeinout","type":0,"oid":"27C2F546-DA39-4A34-9673-ECDC0F752AEF-44726-0000242BC41DC139","startTime":0},{"startValue":"0.000000","isRelative":true,"endValue":"1.000000","identifier":"Opacity","duration":0.66666662693023682,"timingFunction":"easeinout","type":0,"oid":"C2E284D9-D466-4DB6-8231-29D18C8EF408-44726-0000266FC4F4478D","startTime":0.5}],"identifier":"kTimelineDefaultIdentifier","name":"Main Timeline","duration":1.1666666269302368}},"id":"2F544E3C-2DEF-422A-8292-E17F68C7B212-44726-0000240BA4E47EDA","sceneIndex":0,"perspective":"600px","oid":"2F544E3C-2DEF-422A-8292-E17F68C7B212-44726-0000240BA4E47EDA","initialValues":{"67882E1F-96C3-4B8D-B548-0BABF5E18EC2-44726-0000246E65591902":{"Position":"absolute","BackgroundOrigin":"content-box","Display":"inline","Left":"0px","BackgroundImage":"gray-1.png","Height":"294px","Overflow":"visible","Width":"320px","ZIndex":"2","BackgroundSize":"100% 100%","Top":"93px","BackgroundRepeat":"no-repeat","Opacity":"0.000000","ReflectionDepth":"0.000000","InnerHTML":"","TagName":"div","FontSize":"14px"},"27C2F546-DA39-4A34-9673-ECDC0F752AEF-44726-0000242BC41DC139":{"Position":"absolute","BackgroundOrigin":"content-box","Left":"0px","Display":"inline","BackgroundImage":"background.png","Height":"480px","Overflow":"visible","BackgroundSize":"100% 100%","ZIndex":"1","Top":"0px","Width":"325px","Opacity":"0.000000","TagName":"div"},"C2E284D9-D466-4DB6-8231-29D18C8EF408-44726-0000266FC4F4478D":{"Position":"absolute","BackgroundOrigin":"content-box","Display":"inline","Left":"0px","BackgroundImage":"green.png","Height":"294px","Overflow":"visible","Width":"320px","ZIndex":"4","BackgroundSize":"100% 100%","Top":"93px","BackgroundRepeat":"no-repeat","Opacity":"0.000000","TagName":"div","InnerHTML":""}},"name":"Untitled Scene","backgroundColor":"#FFFFFF"}];

var javascriptMapping = {};


	
	var Custom = (function() {
	return {
	};
}());

	
	var hypeDoc = new HYPE();
	
	hypeDoc.attributeTransformerMapping = attributeTransformerMapping;
	hypeDoc.scenes = scenes;
	hypeDoc.javascriptMapping = javascriptMapping;
	hypeDoc.Custom = Custom;
	hypeDoc.currentSceneIndex = 0;
	hypeDoc.mainContentContainerID = "appsbylift_hype_container";
	hypeDoc.resourcesFolderName = resourcesFolderName;
	hypeDoc.showHypeBuiltWatermark = 0;
	hypeDoc.showLoadingPage = false;
	hypeDoc.drawSceneBackgrounds = true;
	hypeDoc.documentName = documentName;

	HYPE.documents[documentName] = hypeDoc.API;

	hypeDoc.documentLoad(this.body);
}());

