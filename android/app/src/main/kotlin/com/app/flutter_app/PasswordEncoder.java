package com.app.flutter_app;

import android.util.Log;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class PasswordEncoder
{
	private static PasswordEncoder instance;


	private final static int ITERATION_COUNT = 5;

	PasswordEncoder()     {
	}

	public synchronized static String encode(String input)throws NoSuchAlgorithmException, IOException
	{
		String encodedPassword = null;
		String saltKey = input.split("#")[0];
		String password = input.split("#")[1];

		Log.e("Email in pencoder = " , saltKey);
		Log.e("Pass in pencoder = " , password);
		byte[] salt = base64ToByte(saltKey);


		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		digest.reset();
		digest.update(salt);
		byte[] btPass = digest.digest(password.getBytes("UTF-8"));
		for (int i = 0; i < ITERATION_COUNT; i++)
		{
			digest.reset();
			btPass = digest.digest(btPass);
		}
		encodedPassword = byteToBase64(btPass);
		return encodedPassword;
	}

	private static byte[] base64ToByte(String str) throws IOException
	{
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] returnbyteArray = decoder.decodeBuffer(str);

//		for(int i = 0; i < returnbyteArray.length ; i++)
//			Log.e("Fn val i = " + i, returnbyteArray[i] + "");



		return returnbyteArray;
	}
	private static String byteToBase64(byte[] bt)
	{
		BASE64Encoder endecoder = new BASE64Encoder();
		String returnString = endecoder.encode(bt);
		return returnString;
	}
}