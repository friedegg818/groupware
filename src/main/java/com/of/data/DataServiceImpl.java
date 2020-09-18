package com.of.data;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.of.common.FileManager;
import com.of.common.dao.CommonDAO;

@Service("data.dataService")
public class DataServiceImpl implements DataService {

	@Autowired
	private CommonDAO dao;

	@Autowired
	private FileManager fileManager;

	@Override
	public void insertData(Data dto, String pathname) throws Exception {
		try {
			int seq = dao.selectOne("data.seq");
			dto.setDataNum(seq);
			dao.insertData("data.insertData", dto);

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

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = dao.selectOne("data.dataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public List<Data> listData(Map<String, Object> map) {
		List<Data> list = null; 
		System.out.println(map.get("dCode"));
		
		try {
			list=dao.selectList("data.listData", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	@Override
	public Data readData(int dataNum) {
		Data dto = null;
		
		try {
			dto = dao.selectOne("data.readData", dataNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}


	@Override
	public Data preReadData(Map<String, Object> map) {
		Data dto = null;
		
		try {
			dto=dao.selectOne("data.preReadData", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public Data nextReadData(Map<String, Object> map) {
		Data dto = null;
		
		try {
			dto=dao.selectOne("data.nextReadData", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public void updateData(Data dto, String pathname) throws Exception {
		try {
			dao.updateData("data.updateData", dto);
			
			if(! dto.getUpload().isEmpty()) {
				for(MultipartFile mf:dto.getUpload()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if(saveFilename==null) continue;
					
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

	@Override
	public void deleteData(int dataNum, String pathname) throws Exception {
		try {
			List<Data> listFile = listFile(dataNum);
			if(listFile!=null) {
				for(Data dto:listFile) {
					fileManager.doFileDelete(dto.getSaveFilename(), pathname);
				}
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "dataNum");
			map.put("num", dataNum);
			deleteFile(map);
			
			dao.deleteData("data.deleteData", dataNum);			
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertFile(Data dto) throws Exception {
		try {
			dao.insertData("data.insertFile", dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Data> listFile(int dataNum) {
		List<Data> listFile=null;
		
		try {
			listFile = dao.selectList("data.listFile", dataNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return listFile;
	}

	@Override
	public Data readFile(int fileNum) {
		Data dto = null;
		
		try {
			dto = dao.selectOne("data.readFile", fileNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	@Override
	public void deleteFile(Map<String, Object> map) throws Exception {
		try {
			dao.deleteData("data.deleteFile", map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertReply(DataReply dto) throws Exception {
		try {
			dao.insertData("data.insertReply", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<DataReply> listReply(Map<String, Object> map) {
		List<DataReply> list = null;
		try {
			list = dao.selectList("data.listReply", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int replyCount(Map<String, Object> map) {
		int result = 0;
		try {
			result = dao.selectOne("data.replyCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void deleteReply(Map<String, Object> map) throws Exception {
		try {
			dao.deleteData("data.deleteReply", map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<DataReply> listReplyAnswer(int answer) {
		List<DataReply> list = null;
		try {
			list = dao.selectList("data.listReplyAnswer", answer);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int replyAnswerCount(int answer) {
		int result = 0;
		try {
			result = dao.selectOne("data.replyAnswerCount", answer);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public int totalFile() {
		int totalFile = 0;
		
		try {
			totalFile = dao.selectOne("data.totalFile");
		} catch (Exception e) {
			return 0;
		}
		
		return totalFile;
	
	}

	@Override
	public int deleteListData(List<String> dataNums) throws Exception {
		int result = 0;
		
		try {
			result = dao.deleteData("data.deleteListData", dataNums);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}						
		return result;
	}

	@Override
	public List<Data> deptListData(Map<String, Object> map) {
		List<Data> list = null; 
		System.out.println(map.get("dCode"));
		try {
			list=dao.selectList("data.deptListData", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;	
	}

}
