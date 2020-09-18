package com.of.profile;

public interface ProfileService {

	public Profile readProfile(String empNo);
	
	public void updateProfile(Profile dto, String pathname) throws Exception;
}