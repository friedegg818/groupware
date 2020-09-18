package com.of.privateaddr;
 
import java.util.List;
import java.util.Map;

public interface PrivateAddrService {
	public List<PrivateAddr> listPrivateAddr(Map<String, Object> map);
	public List<PrivateAddr> listAllPrivateAddr(String empNo);

	public int dataCount(Map<String, Object> map);

	public void insertPrivateAddrSpeed (PrivateAddr dto) throws Exception;
	public void insertPrivateAddr(PrivateAddr dto) throws Exception;
	
	public int modalInsert(PrivateAddr dto) throws Exception;

	public void updatePrivateAddr(PrivateAddr dto) throws Exception;

	public PrivateAddr readAddress(int addrNum);
	
	public List<PrivateAddr> modalList(String empNo);
	
	public void deletePrivateAddr(int addrNum) throws Exception;
}