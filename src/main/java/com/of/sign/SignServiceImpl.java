package com.of.sign;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.of.common.FileManager;
import com.of.common.dao.CommonDAO;

@Service("sign.signService")
public class SignServiceImpl implements SignService {

	@Autowired
	private CommonDAO dao;

	@Autowired
	private FileManager fileManager;

	@Override
	public void insertSign(Sign dto, String pathname, String article, String hiddenSnum) throws Exception {
		try {
			int seq = dao.selectOne("sign.seq");
			dto.setSnum(seq);

			if (article.equals("article")) {
				dao.deleteData("sign.deleteStorage", Integer.parseInt(hiddenSnum));
			}

			dao.insertData("insertSign", dto);
			dao.insertData("insertSignPermission", dto);
			

			if (dto.getSaves() != null) {
				for(int i = 0 ; i < dto.getSaves().size(); i++) {
					dto.setSfSaveFilename(dto.getSaves().get(i));
					dto.setSfOriginalFilename(dto.getOriginals().get(i));
				
					insertFile(dto);
				}
			} else if(dto.getUpload() != null && ! dto.getUpload().isEmpty()) {
				for (MultipartFile mf : dto.getUpload()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if (saveFilename == null)
						continue;

					String originalFilename = mf.getOriginalFilename();

					dto.setSfOriginalFilename(originalFilename);
					dto.setSfSaveFilename(saveFilename);
				}
				insertFile(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void insertFile(Sign dto) throws Exception {
		try {
			dao.insertData("sign.insertSignFile", dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public int dataCount(Map<String, Object> map, String val) {
		int result = 0;
		try {
			if (!val.equals("fini")) {
				map.put("val", "wait");
				result = dao.selectOne("sign.dataCount", map);
			} else {
				map.put("val", "fini");
				result = dao.selectOne("sign.dataCount", map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public List<Sign> listSign(Map<String, Object> map, String keyword) {
		List<Sign> list = null;
		try {
			map.put("val", keyword);
			list = dao.selectList("sign.listSign", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Sign> storageList(Map<String, Object> map) {
		List<Sign> list = null;
		try {
			list = dao.selectList("sign.listStorage", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Sign> empList(String pType, String empNo, Map<String, Object> map) {
		List<Sign> list = null;
		try {
			int intPtype = Integer.parseInt(pType);
			int intEmpNo = Integer.parseInt(empNo);
			list = dao.selectList("sign.emplist", map);
			switch (intPtype) {
			case 1:
				// 사원
				break;
			case 2:
				// 대리
				Iterator<Sign> it = list.iterator();
				Sign dto1 = null;
				while (it.hasNext()) {
					Sign dto = it.next();
					if (intPtype > dto.getpCode() && dto.getpCode() != 6) {
						it.remove();
						
					}

					if (dto.getEmpNo() == intEmpNo) {
						it.remove();
					}

					if (dto.getpCode() == 12) {
						dto1 = dto;
						it.remove();
					}
				}
				
				if(dto1 != null) {
					list.add(dto1);
				}
				
				break;
			case 3:
				// 과장
				it = list.iterator();
				dto1 = null;
				while (it.hasNext()) {
					Sign dto = it.next();
					if (intPtype > dto.getpCode() && dto.getpCode() != 6) {
						it.remove();
						
					}

					if (dto.getEmpNo() == intEmpNo) {
						it.remove();
					}

					if (dto.getpCode() == 12) {
						dto1 = dto;
						it.remove();
					}
				}
				
				if(dto1 != null) {
					list.add(dto1);
				}
				
				break;
			case 4:
				// 차장
				it = list.iterator();
				dto1 = null;
				while (it.hasNext()) {
					Sign dto = it.next();
					if (intPtype > dto.getpCode() && dto.getpCode() != 6) {
						it.remove();
						
					}

					if (dto.getEmpNo() == intEmpNo) {
						it.remove();
					}

					if (dto.getpCode() == 12) {
						dto1 = dto;
						it.remove();
					}
				}
				
				if(dto1 != null) {
					list.add(dto1);
				}
				
				break;
			case 5:
				// 부장
				it = list.iterator();
				dto1 = null;
				while (it.hasNext()) {
					Sign dto = it.next();
					if (intPtype > dto.getpCode() && dto.getpCode() != 6) {
						it.remove();
						
					}

					if (dto.getEmpNo() == intEmpNo) {
						it.remove();
					}

					if (dto.getpCode() == 12) {
						dto1 = dto;
						it.remove();
					}
				}
				
				if(dto1 != null) {
					list.add(dto1);
				}
				
				break;
			case 11:
				// 부사장
				it = list.iterator();
				dto1 = null;
				while (it.hasNext()) {
					Sign dto = it.next();
					if (intPtype > dto.getpCode() && dto.getpCode() != 6) {
						it.remove();
						
					}

					if (dto.getEmpNo() == intEmpNo) {
						it.remove();
					}

					if (dto.getpCode() == 12) {
						dto1 = dto;
						it.remove();
					}
				}
				
				if(dto1 != null) {
					list.add(dto1);
				}
				
				break;
			case 12:
				// 대표이사
				it = list.iterator();
				while (it.hasNext()) {
					Sign dto = it.next();
					if (intPtype > dto.getpCode()) {
						it.remove();
					}

					if (dto.getEmpNo() == intEmpNo) {
						it.remove();
					}
				}
				break;

			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public Sign readSign(Map<String, Object> map) {
		Sign dto = null;
		try {
			dto = dao.selectOne("sign.readSign", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public Sign readEmp(int empNo) {
		Sign dto = null;
		try {
			dto = dao.selectOne("sign.readEmp", empNo);
		} catch (NullPointerException e) {
			dto = null;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public Sign readWriter(int empNo) {
		Sign dto = null;
		try {
			dto = dao.selectOne("sign.readWriter", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public List<Sign> stepList(Map<String, Object> map, String keyword) {
		List<Sign> list = null;
		try {
			list = dao.selectList("sign.stepList", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void updateScurrStep(int sNum) throws Exception {
		dao.updateData("sign.updateScurrStep", sNum);
	}

	@Override
	public int stepCount(Map<String, Object> map) {
		int result = 0;
		try {
			result = dao.selectOne("sign.stepCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public List<Sign> finishList(Map<String, Object> map, String keyword) {
		List<Sign> list = null;
		try {
			list = dao.selectList("sign.finishSignList", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Sign> seatchList(Map<String, Object> map, String keyword) {
		List<Sign> list = null;
		try {
			list = dao.selectList("sign.searchlist", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public void insertReturnSign(Map<String, Object> map) throws Exception {
		try {
			dao.insertData("sign.insertReturnSign", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateScurrStepReturn(int sNum) throws Exception {
		try {
			dao.updateData("sign.updateScurrStepReturn", sNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Sign> returnSignList(Map<String, Object> map) {
		List<Sign> list = null;
		try {
			list = dao.selectList("sign.returnSignList", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public int returnDataCount(int empNo) {
		int result = 0;
		try {
			result = dao.selectOne("sign.returnDataCount", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public Sign readReturnSign(Map<String, Object> map) {
		Sign dto = null;
		try {
			dto = dao.selectOne("sign.readReturnSign", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public void insertStorage(Sign dto, String pathname) throws Exception {
		try {
			String s1="", s2="";
			if (!dto.getUpload().isEmpty()) {
				for (MultipartFile mf : dto.getUpload()) {
					String saveFilename = fileManager.doFileUpload(mf, pathname);
					if (saveFilename == null)
						continue;

					String originalFilename = mf.getOriginalFilename();
					
					s1+=saveFilename+":::";
					s2+=originalFilename+":::";
					
				}
			}
			
			if(s1.length()>0) {
				s1=s1.substring(0, s1.length()-3);
				s2=s2.substring(0, s2.length()-3);
			}
			
			dto.setSfSaveFilename(s1);
			dto.setSfOriginalFilename(s2);
			
			dao.insertData("sign.insertStorage", dto);

		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<Sign> listFile(int snum) {
		List<Sign> listFile = null;
		try {
			listFile = dao.selectList("sign.listFile", snum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listFile;
	}

	@Override
	public Sign readFile(int sfNum) {
		Sign dto = null;
		try {
			dto = dao.selectOne("sign.readFile", sfNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public int storageDataCount(int empNo) {
		int result = 0;
		try {
			result = dao.selectOne("sign.storageDataCount", empNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public Sign readStorage(Map<String, Object> map) {
		Sign dto = null;
		try {
			dto = dao.selectOne("sign.readStorage", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public int searchDataCount(Map<String, Object> map, String val) {
		int result = 0;
		try {
			result = dao.selectOne("sign.searchDataCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void deleteStorage(int valueArr) throws Exception {
		try {
			dao.deleteData("sign.deleteStorage", valueArr);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public int dataCountPermissionLine(List<Sign> list) {
		int result = 0;
		try {
			result = list.size();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}
