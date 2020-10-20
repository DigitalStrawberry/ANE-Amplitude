/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.digitalstrawberry.nativeExtensions.amplitude
{

	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	public class Amplitude extends EventDispatcher
	{
		public static const VERSION:String = "1.4.0";

		private static var mExtContext:ExtensionContext = null;
		
		private static function init():void
		{
			if(Amplitude.isSupported() && mExtContext == null)
			{
				// Create the context
				mExtContext = ExtensionContext.createExtensionContext("com.digitalstrawberry.nativeExtensions.ANEAmplitude", null);
				if(mExtContext == null)
				{
					throw new Error("ANEAmplitude extension could not be created");
				}
				
				// Watch for app open/close events (Android only)
				if(isAndroid)
				{
					NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, startSession, false, 0, true);
					NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, endSession, false, 0, true);	
				}
			}
		}
		
		
		public static function initialize(apiKey:String, userId:String = null, autoTrackSession:Boolean = true):void
		{
			init();
			
			if(mExtContext == null)
			{
				return;
			}

			mExtContext.call("initialize", apiKey, userId, autoTrackSession);
		}
		
		
		public static function setUserId(userId:String):void
		{
			if(mExtContext == null)
			{
				return;
			}
			
			mExtContext.call("setUserId", userId);
		}
		
		
		public static function logEvent(eventName:String, parameters:Object = null):void
		{
			if(mExtContext == null)
			{
				return;
			}
			
			if(parameters)
			{
				var paramArray:Array = new Array();
				for(var key:String in parameters)
				{
					paramArray.push(key);
					paramArray.push(String(parameters[key]));
				}
				
				mExtContext.call("logEvent", eventName, paramArray);
			}
			else
			{
				mExtContext.call("logEvent", eventName);
			}
		}
		
		
		public static function setUserProperties(parameters:Object):void
		{
			if(mExtContext == null)
			{
				return;
			}
			
			var paramArray:Array = new Array();
			for(var key:String in parameters)
			{
				paramArray.push(key);
				paramArray.push(String(parameters[key]));
			}
			
			mExtContext.call("setUserProperties", paramArray);
		}


		public static function setGroupProperties(groupType:String, groupName:String, parameters:Object):void
		{
			if(mExtContext == null)
			{
				return;
			}

			if(groupType == null)
			{
				throw new ArgumentError("Parameter groupType cannot be null.");
			}

			if(groupName == null)
			{
				throw new ArgumentError("Parameter groupName cannot be null.");
			}

			var paramArray:Array = new Array();
			for(var key:String in parameters)
			{
				paramArray.push(key);
				paramArray.push(String(parameters[key]));
			}

			mExtContext.call("setGroupProperties", groupType, groupName, paramArray);
		}


		public static function setGroup(groupType:String, groupName:*):void
		{
			if(mExtContext == null)
			{
				return;
			}

			if(groupType == null)
			{
				throw new ArgumentError("Parameter groupType cannot be null.");
			}

			if(groupName == null)
			{
				throw new ArgumentError("Parameter groupName cannot be null.");
			}

			if(!(groupName is String) && !(groupName is Array))
			{
				throw new ArgumentError("Parameter groupName must be either a String or Array of strings.");
			}

			mExtContext.call("setGroup", groupType, groupName);
		}
		

		public static function setServerUrl(url:String):void
		{
			if(mExtContext == null)
			{
				return;
			}

			if(url == null)
			{
				throw new ArgumentError("Parameter url cannot be null.");
			}

			mExtContext.call("setServerUrl", url);
		}
		
		
		public static function logRevenue(productIdentifier:String, quantity:int, price:Number, receipt:String = null, receiptSignature:String = null, revenueType:String = null,  eventProperties:Object = null):void
		{
			if(mExtContext == null)
			{
				return;
			}

			var eventPropertiesJSON:String = (eventProperties != null) ? JSON.stringify(eventProperties) : null;
			mExtContext.call("logRevenue", productIdentifier, quantity, price, receipt, receiptSignature, revenueType, eventPropertiesJSON);
		}
		
		
		public static function getDeviceId():String
		{
			if(mExtContext == null)
			{
				return '';
			}
			
			return mExtContext.call("getDeviceId") as String;
		}
		
		
		public static function getSessionId():String
		{
			if(mExtContext == null)
			{
				return '';
			}
			
			return mExtContext.call("getSessionId") as String;
		}
		
		
		public static function useAdvertisingIdForDeviceId():void
		{
			init();
			
			if(mExtContext == null)
			{
				return;
			}
			
			mExtContext.call("useAdvertisingIdForDeviceId");
		}
		
		
		private static function startSession(event:Event):void
		{
			if(mExtContext == null)
			{
				return;
			}
			
			mExtContext.call("startSession");
		}
		
		
		private static function endSession(event:Event):void
		{
			if(mExtContext == null)
			{
				return;
			}
			
			mExtContext.call("endSession");
		}

		
		public static function isSupported():Boolean
		{
			return isiOS || isAndroid;
		}
		
		
		public static function get isiOS():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1;
		}
		
		
		public static function get isAndroid():Boolean
		{
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}
	}
}