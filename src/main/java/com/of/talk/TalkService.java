package com.of.talk;

import java.util.List;
import java.util.Map;

public interface TalkService {
	public void insertTalk(Talk dto) throws Exception;
	public List<Talk> listTalk(Map<String, Object>map);
	public int dataCount();
	public void deleteTalk(Map<String, Object> map) throws Exception;
}
