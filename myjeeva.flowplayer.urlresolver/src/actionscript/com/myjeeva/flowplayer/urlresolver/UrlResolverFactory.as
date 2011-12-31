/*
* URL Resolver plugin for Flowplayer
*
* Author		: Jeeva (jeeva@myjeeva.com)
* Copyright (c) 2011 www.myjeeva.com
*
*    You should have received a copy of the The MIT License
*    along with this plugin.  If not, see <http://http://www.opensource.org/licenses/mit-license.php>.
*
*/

package com.myjeeva.flowplayer.urlresolver
{
	import com.myjeeva.flowplayer.urlresolver.UrlResolver;
	
	import flash.display.Sprite;
	
	import org.flowplayer.model.PluginFactory;
	
	public class UrlResolverFactory extends Sprite implements PluginFactory
	{	
		public function newPlugin():Object
		{			
			return new UrlResolver();
		}
	}
}