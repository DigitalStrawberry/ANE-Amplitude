package
{
	import com.digitalstrawberry.nativeExtensions.amplitude.Amplitude;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Main extends Sprite
	{
		// -------------------------------------------------
		// -------------------------------------------------
		// TODO: Replace this with your Amplitude API key
		// -------------------------------------------------
		// -------------------------------------------------
		private var apiKey:String = "dcc80f7d0d3b84134b35f7b9eeca7e1e";
		
		private var buttonFormat:TextFormat;
		private var feedback : TextField;
		
		public function Main()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			feedback = new TextField();
			var format : TextFormat = new TextFormat();
			format.font = "_sans";
			format.size = 16;
			format.color = 0x000000;
			feedback.defaultTextFormat = format;
			feedback.width = 400;
			feedback.height = 260;
			feedback.x = 10;
			feedback.y = 210;
			feedback.multiline = true;
			feedback.wordWrap = true;
			addChild(feedback);

			log("Running Amplitude ANE v" + Amplitude.VERSION);
			
			createButtons();
		}
		
		private function createButtons() : void
		{
			// Row
			var tf:TextField = createButton("Initialize");
			tf.x = 10;
			tf.y = 10;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, initialize);
			addChild(tf);
			
			tf = createButton("Initialize with Id");
			tf.x = 170;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, initializeWithId);
			addChild(tf);
			
			tf = createButton("Get Device Id");
			tf.x = 330;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, getDeviceId);
			addChild(tf);
			
			
			// Row
			tf = createButton("Set User Id");
			tf.x = 10;
			tf.y = 50;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, setUserId);
			addChild(tf);
			
			tf = createButton("Log Event");
			tf.x = 170;
			tf.y = 50;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, logEvent);
			addChild(tf);
			
			tf = createButton("Log Event Params");
			tf.x = 330;
			tf.y = 50;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, logEventWithParams);
			addChild(tf);

			
			// Row
			tf = createButton("Set User Prop");
			tf.x = 10;
			tf.y = 90;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, setUserProperties);
			addChild(tf);
			
			tf = createButton("Use IDFA");
			tf.x = 170;
			tf.y = 90;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, useIDFA);
			addChild(tf);
			
			tf = createButton("Log Revenue");
			tf.x = 330;
			tf.y = 90;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, logRevenue);
			addChild(tf);


			// Row
			tf = createButton("Set User Group");
			tf.x = 10;
			tf.y = 130;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, setGroup);
			addChild(tf);

			tf = createButton("Set User Groups");
			tf.x = 170;
			tf.y = 130;
			tf.addEventListener( MouseEvent.MOUSE_DOWN, setGroups);
			addChild(tf);

			tf = createButton("Set Group Prop");
			tf.x = 330;
			tf.y = 130;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, setGroupProperties);
			addChild(tf);

			tf = createButton("Get Session Id");
			tf.x = 10;
			tf.y = 170;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, getSessionId);
			addChild(tf);
			
		}
		
		private function log(text:String, clear:Boolean = true):void
		{
			if(clear)
			{
				feedback.text = "";
			}
			
			feedback.text += text + "\n\r";
		}
		
		private function createButton( label : String ) : TextField
		{
			if ( !buttonFormat )
			{
				buttonFormat = new TextFormat();
				buttonFormat.font = "_sans";
				buttonFormat.size = 14;
				buttonFormat.bold = true;
				buttonFormat.color = 0xFFFFFF;
				buttonFormat.align = TextFormatAlign.CENTER;
			}
			
			var textField : TextField = new TextField();
			textField.defaultTextFormat = buttonFormat;
			textField.width = 140;
			textField.height = 30;
			textField.text = label;
			textField.backgroundColor = 0xCC0000;
			textField.background = true;
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			return textField;
		}
		
		
		private function initialize(event:MouseEvent):void
		{
			log("Amplitude.initialize(key) with auto track session!");

			if(apiKey == "")
			{
				log("Amplitude API key not specified!");
			}

			Amplitude.initialize(apiKey, null, true);
		}
		
		private function initializeWithId(event:MouseEvent):void
		{
			var userId:Number = Math.floor(Math.random() * 99999);
			
			log("Amplitude.initialize(key, 'user_" + userId + "') + auto session track");
			Amplitude.initialize(apiKey, "user_" + userId, true);
		}
		
		private function getDeviceId(event:MouseEvent):void
		{
			log("Amplitude device id = " + Amplitude.getDeviceId());
		}

		private function getSessionId(event:MouseEvent):void
		{
			log("Amplitude session id = " + Amplitude.getSessionId());
		}
		
		private function setUserId(event:MouseEvent):void
		{
			var userId:Number = Math.floor(Math.random() * 99999);
			
			log("Amplitude.setUserId('user_" + userId + "')");
			Amplitude.setUserId("user_" + userId);
		}
		
		private function logEvent(event:MouseEvent):void
		{
			log("Amplitude.logEvent('button_clicked')");
			Amplitude.logEvent("button_clicked");
		}
		
		private function logEventWithParams(event:MouseEvent):void
		{
			var param1:Number = Math.floor(Math.random() * 1000);
			var param2:Number = Math.floor(Math.random() * 1000);
			
			log("Amplitude.logEvent('button_clicked', {param1: " + param1 + ", param2: " + param2 + "})");
			Amplitude.logEvent("button_clicked", {param1: param1, param2: param2});
		}
		
		private function setUserProperties(event:MouseEvent):void
		{
			var param1:Number = Math.floor(Math.random() * 9999);
			
			log("Amplitude.setUserProperties({param1: " + param1 + "});");
			Amplitude.setUserProperties({param1: param1});
		}
		
		private function useIDFA(event:MouseEvent):void
		{
			log("Amplitude.useAdvertisingIdForDeviceId()");
			Amplitude.useAdvertisingIdForDeviceId();
		}
		
		private function logRevenue(event:MouseEvent):void
		{
			log("Amplitude.logRevenue('com.example.productname', 1, 2.99)");
			Amplitude.logRevenue("com.example.productname", 1, 2.99, null, null, "income", {prop1: "value1", prop2: "value2"});
		}

		private function setGroup(event:MouseEvent):void
		{
			log("Amplitude.setGroup('organizationId', '1337')");
			Amplitude.setGroup("organizationId", "1337");
		}

		private function setGroups(event:MouseEvent):void
		{
			log("Amplitude.setGroup('sport', ['tennis', 'baseball'])");
			Amplitude.setGroup("sport", ["tennis", "baseball"]);
		}

		private function setGroupProperties(event:MouseEvent):void
		{
			log("Amplitude.setGroupProperties('company', 'Company LLC', { members: 13 })");
			Amplitude.setGroupProperties("company", "Company LLC", { members: 13 });
		}
		
	}
}