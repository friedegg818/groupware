package com.of.publicAddr;

import java.util.List;
import java.util.Map;

public interface PublicAddrService {
	public List<PublicAddr> listPublicAddr(Map<String, Object> map);
	public List<PublicAddr> listAllPublicAddr();
	
	public int dataCount(Map<String, Object> map);
	
	public PublicAddr readpublicAddr(int empNo);
	
}
