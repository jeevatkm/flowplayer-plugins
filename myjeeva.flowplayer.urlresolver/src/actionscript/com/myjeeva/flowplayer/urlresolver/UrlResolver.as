/*
 * URL Resolver plugin for Flowplayer
 *
 * @author		: Jeeva (jeeva@myjeeva.com)
 * Desc			: Clip URL resolver for FlowPlayer to resolve the URL at runtime
 * Copyright 	: (c) 2010-2012 www.myjeeva.com
 *
 *    You should have received a copy of the The MIT License
 *    along with this plugin.  If not, see <http://http://www.opensource.org/licenses/mit-license.php>.
 *
 */

package com.myjeeva.flowplayer.urlresolver
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.flowplayer.controller.ClipURLResolver;
	import org.flowplayer.controller.StreamProvider;
	import org.flowplayer.model.Clip;
	import org.flowplayer.model.Plugin;
	import org.flowplayer.model.PluginModel;
	import org.flowplayer.util.Log;
	import org.flowplayer.view.Flowplayer;
	
	/**
	 * Clip URL resolver for FlowPlayer to resolve the URL at runtime
	 * 
	 * @inheritDoc 
	 * 
	 * @see ClipURLResolver
	 * @see Plugin
	 * @see EventDispatcher
	 */
	public class UrlResolver extends EventDispatcher implements ClipURLResolver, Plugin
	{
		private var log:Log = new Log(this);		
		private var urlLoader:URLLoader = null;
		private var _failureListener:Function;
		private var _player:Flowplayer;
		private var _model:PluginModel;
		private var _successListener:Function;
		private var _clip:Clip;
		
		public function UrlResolver() { }
		
		public function set onFailure(listener:Function):void
		{
			_failureListener = listener;
		}
		
		/**
		 * this method gets invoked when clicking on play button on Flowplayer
		 * 
		 * @param provider:StreamProvider
		 * @param clip:Clip
		 * @param successListener:Function
		 * 
		 * @see StreamProvider
		 * @see Clip
		 * @see Function
		 * 
		 * @since 1.0.0
		 */
		public function resolve(provider:StreamProvider, clip:Clip, successListener:Function):void
		{	
			ExternalInterface.call(Constants.JS_PROGRESS_UPDATE_METHOD, Constants.CLIP_RESOLVER_INVOKED);
			_clip = clip;
			_successListener = successListener;
			var requestUrl:String = clip.getCustomProperty(Constants.CLIP_URL_PROVIDER).toString();
			if(StringUtil.stringHasValue(requestUrl)) 
			{
			 	perfromUrlRequest(requestUrl);
			}
			else
			{
				ExternalInterface.call(Constants.JS_PROGRESS_UPDATE_METHOD, Constants.CLIP_RESOLVER_URLPROVIDER_EMPTY);
				_player.stop();
			}
		}
		
		public function handeNetStatusEvent(event:NetStatusEvent):Boolean
		{
			return true;
		}
		
		public function onConfig(model:PluginModel):void
		{
			_model = model;
		}
		
		public function onLoad(player:Flowplayer):void
		{
			_player = player;
			_model.dispatchOnLoad();
		}
		
		public function getDefaultConfig():Object
		{	
			return null;
		}
		
		/**
		 * perform the HTTP request and retrive the binary steam as String from the request
		 * 
		 * @param requestUrl:String
		 */
		private function perfromUrlRequest(requestUrl:String):void 
		{
			urlLoader = new URLLoader();
			
			//assigning DataFormat
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			// adding event listeners
			addURLLoaderListeners();
			
			var variables:URLVariables = new URLVariables();  
			var request:URLRequest = new URLRequest(requestUrl);             
			request.method = URLRequestMethod.GET;             
			request.data = variables;
			
			// loading a request
			ExternalInterface.call(Constants.JS_PROGRESS_UPDATE_METHOD, Constants.CLIP_URL_PROVIDER_INVOKED);
			urlLoader.load(request);     
		}
		
		/** 
		 * event error handler for any Securiy error 
		 * 
		 * @see Event
		 */
		private function securityErrorHandler(e:Event):void
		{
			trace("securityErrorHandler:" + e);
			doError();
		}
		
		/** 
		 * event error handler for any IO error 
		 * 
		 * @see Event
		 */
		private function ioErrorHandler(e:Event):void
		{
			trace("ioErrorHandler: " + e);
			doError();
		}
		
		/** propagates the ERROR event */
		public function doError():void 
		{
			dispatchEvent(new Event(Constants.LOAD_ERROR));
		}
		
		/**
		 * this completeHandler(e:Event) gets invoked on completion of URL request
		 * and collects the response from request
		 * 
		 * @param e:Event
		 * @see Event
		 */
		private function completeHandler(e:Event):void
		{   
			ExternalInterface.call(Constants.JS_PROGRESS_UPDATE_METHOD, Constants.CLIP_URL_PROVIDER_RESPONSE_RECEIVED);
			trace("URL request completed");	
			var result:String = e.target.data.toString();
			if(StringUtil.stringHasValue(result)) 
			{					
				_clip.setResolvedUrl(this, StringUtil.trim(result));
				_successListener(_clip);
				ExternalInterface.call(Constants.JS_PROGRESS_UPDATE_METHOD, Constants.CLIP_URL_PROVIDER_SUCCESSLISTENER_CALLED);
				trace("response data: " + result);
				removeURLLoaderListeners();
			} 
			else
			{
				ExternalInterface.call(Constants.JS_PROGRESS_UPDATE_METHOD, Constants.CLIP_URL_PROVIDER_ERROROCCURED);
				_player.stop();
			}
		}
		
		/** adds the event listener to @see URLLoader */
		private function addURLLoaderListeners():void
		{
			urlLoader.addEventListener(Event.COMPLETE, completeHandler); 
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		/** removes the event listener to @see URLLoader */
		private function removeURLLoaderListeners():void 
		{
			urlLoader.removeEventListener(Event.COMPLETE, completeHandler); 
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
	}
}