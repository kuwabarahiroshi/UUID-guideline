/**
 * 
 */
// package com.beenos.lib;

import java.util.UUID;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

/**
 * インストール毎にユニークなIDを返す
 *
 * @see http://bit.ly/1kDHp8G
 * @see http://bit.ly/1kDHlWA
 */
public class UIID {
	private static String uiid = null;
	private static final String PREFERENCE_KEY = "beenos.UIID";

	/**
	 *
	 */
	public synchronized static String id(Context context)
	{
		if (uiid != null) {
			return uiid;
		}

		SharedPreferences prefs = context.getSharedPreferences(PREFERENCE_KEY, Context.MODE_PRIVATE);
		uiid = prefs.getString(PREFERENCE_KEY, null);
		if (uiid == null) {
			uiid = UUID.randomUUID().toString();
			Editor editor = prefs.edit();
			editor.putString(PREFERENCE_KEY, uiid);
			editor.commit();
		}

		return uiid;
	}
}

