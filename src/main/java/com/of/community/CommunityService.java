package com.of.community;

import java.util.List;
import java.util.Map;

public interface CommunityService {
	public void insertCommu(Community dto, String pathname) throws Exception;
	public void insertClub(Community dto) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<Community> listCommu(Map<String, Object> map);
	public List<Community> listClub(Map<String, Object> map);
	
	public void updateHitCount(int commuNum) throws Exception;
	
	public Community readCommu(int num);
	public Community preReadCommu(Map<String, Object> map);
	public Community nextReadCommu(Map<String, Object> map);
	
	public void updateCommu(Community dto, String pathname) throws Exception;
	public void deleteCommu(int num, String pathname) throws Exception;
	
	public void insertFile(Community dto) throws Exception;
	public List<Community> listFile(int num);
	public Community readFile(int fileNum);
	public void deleteFile(Map<String, Object> map) throws Exception;
	
	public void insertCommuLike(Map<String, Object> map) throws Exception; 	// 게시글 좋아요 등록
	public int commuLikeCount(int num);
	
	public void insertReply(CommuReply dto) throws Exception;
	public List<CommuReply> listReply(Map<String, Object> map);
	public int replyCount(Map<String, Object> map); 		
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	public List<CommuReply> listReplyAnswer(int answer);		// 답글 리스트
	public int replyAnswerCount(int answer);			// 답글 개수 
	
	public void insertReplyLike(Map<String, Object> map) throws Exception;		// 댓글 좋아요 추가
	public Map<String, Object> replyLikeCount(Map<String, Object> map);			// 댓글 좋아요, 싫어요 개수 
}
