package com.of.news;

import java.util.List;
import java.util.Map;

public interface NewsService{
	public void insertNews(News dto) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<News> listNews(Map<String, Object> map);
	
	public News readNews(int newsNum);
	public News preReadNews(Map<String, Object> map);
	public News nextReadNews(Map<String, Object> map);
	
	public void updateNews(News dto) throws Exception;
	public void deleteNews(int newsNum, String writer) throws Exception;
	
	public void insertReply(NewsReply dto) throws Exception;
	public int replyCount(Map<String, Object> map);
	public List<NewsReply> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map)throws Exception;
	
	public int dataCountAlert(Map<String, Object> map);
}
