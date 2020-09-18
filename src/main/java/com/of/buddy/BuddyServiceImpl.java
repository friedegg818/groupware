package com.of.buddy;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.of.common.FileManager;
import com.of.common.dao.CommonDAO;

@Service("buddy.buddyService")
public class BuddyServiceImpl implements BuddyService {
	@Autowired
	CommonDAO dao;

	@Autowired
	private FileManager fileManager;
	
	@Override	// 받는 사람 리스트 
	public List<Buddy> listAddr(Map<String, Object> map) {
		List<Buddy> adlist = null;
		
		try {
			adlist = dao.selectList("buddy.listReceiver", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return adlist;
	}
	
	@Override	// 메일 전송 
	public void sendBuddy(Buddy dto, String pathname) throws Exception {
		try {
			int seq = dao.selectOne("buddy.seq");
			dto.setBuddyNum(seq);
			dao.insertData("buddy.sendBuddy1", dto);
			dao.insertData("buddy.sendBuddy2", dto);
			
			String []ss = dto.getReceiver().split(",");
			for(int i=0; i<ss.length; i++) {
				dto.setReceiver(ss[i]);				
				dao.insertData("buddy.sendBuddy3", dto);
			}
			
			// 파일 업로드
			if (!dto.getUpload().isEmpty()) {
				for (MultipartFile mf : dto.getUpload()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if (saveFilename == null)
						continue;

					String originalFilename = mf.getOriginalFilename();
					long fileSize = mf.getSize();
					
					dto.setOriginalFilename(originalFilename);
					dto.setSaveFilename(saveFilename);
					dto.setFileSize(fileSize);

					insertFile(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

	}
	
	@Override	// 답장 쓰기 
	public void replyBuddy(Buddy dto, int buddyNum, String pathname) throws Exception {
		try {
			int seq = dao.selectOne("buddy.seq");
			dto.setBuddyNum(seq);
			dao.insertData("buddy.sendBuddy1", dto);
			dao.insertData("buddy.sendBuddy2", dto);
			
			String []ss = dto.getReceiver().split(",");
			for(int i=0; i<ss.length; i++) {
				dto.setReceiver(ss[i]);				
				dao.insertData("buddy.sendBuddy3", dto);
			}
			
			// 파일 업로드
			if (!dto.getUpload().isEmpty()) {
				for (MultipartFile mf : dto.getUpload()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if (saveFilename == null)
						continue;

					String originalFilename = mf.getOriginalFilename();
					long fileSize = mf.getSize();
					
					dto.setOriginalFilename(originalFilename);
					dto.setSaveFilename(saveFilename);
					dto.setFileSize(fileSize);

					insertFile(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	
	@Override // 전달하기 
	public void forwardBuddy(Buddy dto, int buddyNum, String pathname) throws Exception {
		try {
			int seq = dao.selectOne("buddy.seq");
			dto.setBuddyNum(seq);
			dao.insertData("buddy.sendBuddy1", dto);
			dao.insertData("buddy.sendBuddy2", dto);
			
			String []ss = dto.getReceiver().split(",");
			for(int i=0; i<ss.length; i++) {
				dto.setReceiver(ss[i]);				
				dao.insertData("buddy.sendBuddy3", dto);
			}
			
			// 파일 업로드
			if (!dto.getUpload().isEmpty()) {
				for (MultipartFile mf : dto.getUpload()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if (saveFilename == null)
						continue;

					String originalFilename = mf.getOriginalFilename();
					long fileSize = mf.getSize();
					
					dto.setOriginalFilename(originalFilename);
					dto.setSaveFilename(saveFilename);
					dto.setFileSize(fileSize);

					insertFile(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	
	@Override	// 받은 편지함 개수 
	public int rbuddyCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = dao.selectOne("buddy.rDataCount", map);
		} catch (Exception e) {
		}
		
		return result;
	}

	@Override	// 보낸 편지함 개수 
	public int sbuddyCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = dao.selectOne("buddy.sDataCount", map);
		} catch (Exception e) {
		}
		
		return result;
	}

	@Override	// 중요 보관함 개수
	public int keepCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = dao.selectOne("buddy.keepCount", map);
		} catch (Exception e) {
		}
		
		return result;
	}
	
	@Override	// 읽지 않은 메일 개수 
	public int unreadCount(String receiver) {
		int result = 0;
		
		try {
			result = dao.selectOne("buddy.unreadCount", receiver);
		} catch (Exception e) {
		}
		
		return result;
	}

	@Override	// 받은 편지함  리스트
	public List<Buddy> listRbuddy(Map<String, Object> map) {
		List<Buddy>rlist = null;
		
		try {
			rlist = dao.selectList("buddy.listRbuddy", map);
		} catch (Exception e) {
		}
		
		return rlist;
	}

	@Override	// 보낸 편지함 리스트
	public List<Buddy> listSbuddy(Map<String, Object> map) {
		List<Buddy>slist = null;
		
		try {
			slist = dao.selectList("buddy.listSbuddy", map);
		} catch (Exception e) {
		}
		
		return slist;
	}

	@Override	// 중요 보관함 리스트
	public List<Buddy> listKeep(Map<String, Object> map) {
		List<Buddy>klist = null;
		
		try {
			klist = dao.selectList("buddy.keepList", map);
		} catch (Exception e) {
		}

		return klist;
	}

	@Override	// 받은 메일 읽기
	public Buddy readBuddy(int buddyNum) {
		Buddy dto = null;
		
		try {
			dto = dao.selectOne("buddy.readBuddy", buddyNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	@Override	// 보낸 메일 읽기
	public Buddy readSendBuddy(Map<String, Object> map) {
		Buddy dto = null;
		
		try {
			dto = dao.selectOne("buddy.readSendBuddy", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public Buddy preReadBuddy(Map<String, Object> map) {
		Buddy dto = null;
		
		try {
			dto = dao.selectOne("buddy.preReadBuddy", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public Buddy nextReadBuddy(Map<String, Object> map) {
		Buddy dto = null;
		
		try {
			dto = dao.selectOne("buddy.nextReadBuddy", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
		
	}

	@Override	// 메일 삭제
	public void deleteBuddy(int buddyNum, String pathname) throws Exception {
		try {
			List<Buddy> listFile = listFile(buddyNum);
			if(listFile!=null) {
				for(Buddy dto:listFile) {
					fileManager.doFileDelete(dto.getSaveFilename(), pathname);
				}
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "buddyNum");
			map.put("num", buddyNum);
			deleteFile(map);
			
			dao.deleteData("buddy.deleteBuddy", buddyNum);			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override	// 체크한 메일 삭제
	public int deleteListBuddy(List<String> buddyNums) throws Exception {
		int result = 0;
		
		try {
			result = dao.deleteData("buddy.deleteListBuddy", buddyNums);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return result;
	}

	@Override
	public void insertFile(Buddy dto) throws Exception {
		try {
			dao.insertData("buddy.insertFile", dto);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Override
	public List<Buddy> listFile(int buddyNum) {
		List<Buddy> listFile=null;
		
		try {
			listFile = dao.selectList("buddy.listFile", buddyNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listFile;
	}

	@Override
	public Buddy readFile(int fileNum) {
		Buddy dto = null;
		
		try {
			dto = dao.selectOne("buddy.readFile", fileNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override	// 파일 삭제 
	public void deleteFile(Map<String, Object> map) throws Exception {
		try {
			dao.deleteData("buddy.deleteFile", map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

	}
	

	@Override	// 읽음 표시 
	public void updateCheck(int buddyNum) throws Exception {
		try {
			dao.updateData("buddy.updateCheck", buddyNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override	// 중요 표시 (보관)
	public void updateState(int buddyNum) throws Exception {
		try {
			dao.updateData("buddy.updateState", buddyNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	
	@Override	// 중요 표시 (해제)
	public void updateState2(int buddyNum) throws Exception {
		try {
			dao.updateData("buddy.updateState2", buddyNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	

	





	

	

	
	
}
