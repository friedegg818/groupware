package com.of.data;

import java.util.List;
import java.util.Map;

public interface DataService {
public void insertData(Data dto, String pathname) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<Data> listData(Map<String, Object> map);
	public List<Data> deptListData(Map<String, Object> map);
	public int totalFile();

	public Data readData(int num);
	public Data preReadData(Map<String, Object> map);
	public Data nextReadData(Map<String, Object> map);
	
	public void updateData(Data dto, String pathname) throws Exception;
	public void deleteData(int Data, String pathname) throws Exception;
	public int deleteListData(List<String> dataNums) throws Exception;
	
	public void insertFile(Data dto) throws Exception;
	public List<Data> listFile(int num);
	public Data readFile(int fileNum);
	public void deleteFile(Map<String, Object> map) throws Exception;
		
	public void insertReply(DataReply dto) throws Exception;
	public List<DataReply> listReply(Map<String, Object> map);
	public int replyCount(Map<String, Object> map); 		
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public List<DataReply> listReplyAnswer(int answer);		// 답글 리스트
	public int replyAnswerCount(int answer);			// 답글 개수 
	
}
