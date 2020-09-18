package com.of.profile;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.FileManager;
import com.of.common.dao.CommonDAO;

@Service("profile.profileServiceImpl")
public class ProfileServiceImpl implements ProfileService {
	@Autowired
	private CommonDAO dao;

	@Autowired
	private FileManager fileManager;
	
/*	@Override
	public void insertProfile(Profile dto, String pathname) throws Exception {
		try {
			if(dto.getUpload()!=null && ! dto.getUpload().isEmpty()) {
				// 파일 업로드
				String newFilename=fileManager.doFileUpload(dto.getUpload(), pathname);
				dto.setImageFilename(newFilename);

				dao.insertData("profile.insertProfile", dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}*/


	@Override
	public void updateProfile(Profile dto, String pathname) throws Exception {
		try {
			// 업로드한 파일이 존재한 경우
			if(dto.getUpload()!=null && !dto.getUpload().isEmpty()) {
				String newFilename = fileManager.doFileUpload(dto.getUpload(), pathname);
		
				if (newFilename != null) {
					// 이전 파일 지우기
					Profile vo = readProfile(dto.getEmpNo());
					if(vo!=null && vo.getImageFilename()!=null) {
						fileManager.doFileDelete(vo.getImageFilename(), pathname);
					}
					
					dto.setImageFilename(newFilename);
				}
			}
			
			dao.updateData("profile.updateProfile1", dto);
			dao.updateData("profile.updateProfile2", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}


	@Override
	public Profile readProfile(String empNo) {
		Profile dto=null;
		
		try {
			dto=dao.selectOne("profile.readProfile", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}
}
