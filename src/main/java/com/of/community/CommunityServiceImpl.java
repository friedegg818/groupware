package com.of.community;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.of.common.FileManager;
import com.of.common.dao.CommonDAO;

@Service("community.communityService")
public class CommunityServiceImpl implements CommunityService {
	@Autowired
	private CommonDAO dao;
	
	@Autowired
	private FileManager fileManager;
	
	@Override
	public void insertCommu(Community dto, String pathname) throws Exception {
		try {
			int seq=dao.selectOne("community.seq");
			dto.setCommuNum(seq);				
			dao.insertData("community.insertCommu", dto);
			
			// 파일 업로드
			if(! dto.getUpload().isEmpty()) {
				for(MultipartFile mf:dto.getUpload()) {
					String saveFilename=fileManager.doFileUpload(mf, pathname);
					if(saveFilename==null) continue;

					String originalFilename=mf.getOriginalFilename();
					
					dto.setOriginalFilename(originalFilename);
					dto.setSaveFilename(saveFilename);				
					
					insertFile(dto);
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result=0;
		
		try {
			result=dao.selectOne("community.dataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@Override
	public List<Community> listCommu(Map<String, Object> map) {
		List<Community> list=null;
		
		try {
			list=dao.selectList("community.listCommu", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}

	@Override
	public Community readCommu(int commuNum) {
		Community dto=null;

		try {
			dto=dao.selectOne("community.readCommu", commuNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void updateHitCount(int commuNum) throws Exception {
		try {
			dao.updateData("community.updateHitCount", commuNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public Community preReadCommu(Map<String, Object> map) {
		Community dto=null;

		try {
			dto=dao.selectOne("community.preReadCommu", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public Community nextReadCommu(Map<String, Object> map) {
		Community dto=null;

		try {
			dto=dao.selectOne("community.nextReadCommu", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void updateCommu(Community dto, String pathname) throws Exception {
		try {
			dao.updateData("community.updateCommu", dto);
			
			if(! dto.getUpload().isEmpty()) {
				for(MultipartFile mf:dto.getUpload()) {
					String saveFilename=fileManager.doFileUpload(mf, pathname);
					if(saveFilename==null) continue;
					
					String originalFilename=mf.getOriginalFilename();
								
					dto.setOriginalFilename(originalFilename);
					dto.setSaveFilename(saveFilename);
			
					
					insertFile(dto);
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void deleteCommu(int commuNum, String pathname) throws Exception {
		try {
			// 파일 지우기
			List<Community> listFile=listFile(commuNum);
			if(listFile!=null) {
				for(Community dto:listFile) {
					fileManager.doFileDelete(dto.getSaveFilename(), pathname);
				}
			}
			
			// 파일 테이블 내용 지우기
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("field", "commuNum");
			map.put("num", commuNum);
			deleteFile(map);
			
			dao.deleteData("community.deleteCommu", commuNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertFile(Community dto) throws Exception {
		try {
			dao.insertData("community.insertFile", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public List<Community> listFile(int commuNum) {
		List<Community> listFile=null;
		
		try {
			listFile=dao.selectList("community.listFile", commuNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return listFile;
	}

	@Override
	public Community readFile(int fileNum) {
		Community dto=null;
		
		try {
			dto=dao.selectOne("community.readFile", fileNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void deleteFile(Map<String, Object> map) throws Exception {
		try {
			dao.deleteData("community.deleteFile", map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	// 게시글 좋아요
		@Override
		public void insertCommuLike(Map<String, Object> map) throws Exception {
			try {
				dao.insertData("community.insertCommuLike", map);
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}

		}
		
		// 게시글 좋아요 개수 
		@Override
		public int commuLikeCount(int commuNum) {
			int result = 0;
			try {
				result = dao.selectOne("community.commuLikeCount", commuNum);
			} catch (Exception e) {
				e.printStackTrace();
			}

			return result;
		}
	
	// 댓글 입력 
		@Override
		public void insertReply(CommuReply dto) throws Exception {
			try {
				dao.insertData("community.insertReply", dto);
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
		}
		
		// 댓글 리스트 
		@Override
		public List<CommuReply> listReply(Map<String, Object> map) {
			List<CommuReply> list = null;
			try {
				list = dao.selectList("community.listReply", map);
			} catch (Exception e) {
				e.printStackTrace();
			}

			return list;
		}
		
		// 댓글 개수 
		@Override
		public int replyCount(Map<String, Object> map) {
			int result = 0;
			try {
				result = dao.selectOne("community.replyCount", map);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}

		// 댓글&답글 동시 지우기 
		@Override
		public void deleteReply(Map<String, Object> map) throws Exception {
			try {
				dao.deleteData("community.deleteReply", map);
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}

		}
		
		// 답글 리스트 
		@Override
		public List<CommuReply> listReplyAnswer(int answer) {
			List<CommuReply> list = null;
			try {
				list = dao.selectList("community.listReplyAnswer", answer);
			} catch (Exception e) {
				e.printStackTrace();
			}

			return list;
		}
		
		// 답글 개수 
		@Override
		public int replyAnswerCount(int answer) {
			int result = 0;
			try {
				result = dao.selectOne("community.replyAnswerCount", answer);
			} catch (Exception e) {
				e.printStackTrace();
			}

			return result;
		}
		
		// 댓글 좋아요&싫어요 
		@Override
		public void insertReplyLike(Map<String, Object> map) throws Exception {
			try {
				dao.insertData("community.insertReplyLike", map);
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}

		}
		
		// 좋싫 개수 
		@Override
		public Map<String, Object> replyLikeCount(Map<String, Object> map) {
			Map<String, Object> countMap = null;
			try {
				countMap = dao.selectOne("community.replyLikeCount", map);
			} catch (Exception e) {
				e.printStackTrace();
			}

			return countMap;
		}

		@Override
		public List<Community> listClub(Map<String, Object> map) {
			List<Community> listClub=null;
			
			try {
				listClub=dao.selectList("community.listClub", map);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			return listClub;
		}

		@Override
		public void insertClub(Community dto) throws Exception {
			try {					
				dao.insertData("community.insertClub", dto);		
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
			
		}
}
