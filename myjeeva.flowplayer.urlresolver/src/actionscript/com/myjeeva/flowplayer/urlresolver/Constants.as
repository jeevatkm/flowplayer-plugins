/*
 * Constants - URL Resolver plugin for Flowplayer
 *
 * @author		: Jeeva (jeeva@myjeeva.com)* 
 * Desc			: Constants definition for Clip URL resolver
 * Copyright 	: (c) 2010-2012 www.myjeeva.com
 *
 *    You should have received a copy of the The MIT License
 *    along with this plugin.  If not, see <http://http://www.opensource.org/licenses/mit-license.php>.
 *
 */

package com.myjeeva.flowplayer.urlresolver
{
	/** ========== defining all constants here ===========*/
	public class Constants
	{	
		//custom properties as constants
		public static const CLIP_URL_PROVIDER:String = "urlProvider";
		
		
		//events releated constans here
		public static const LOAD_ERROR:String = "error";
		
		//JS method name's and its response CODE as constants
		public static const JS_PROGRESS_UPDATE_METHOD:String = "urlResolverProgress";
		public static const CLIP_RESOLVER_INVOKED:String = "CLIP_RESOLVER_INVOKED";
		public static const CLIP_RESOLVER_URLPROVIDER_EMPTY:String = "CLIP_RESOLVER_URLPROVIDER_EMPTY";
		public static const CLIP_URL_PROVIDER_INVOKED:String = "CLIP_URL_PROVIDER_INVOKED";
		public static const CLIP_URL_PROVIDER_RESPONSE_RECEIVED:String = "CLIP_URL_PROVIDER_RECEIVEDURL";
		public static const CLIP_URL_PROVIDER_SUCCESSLISTENER_CALLED:String = "CLIP_URL_PROVIDER_SUCCESSLISTENER_CALLED";
		public static const CLIP_URL_PROVIDER_ERROROCCURED:String = "CLIP_URL_PROVIDER_ERROROCCURED";		
	}
}