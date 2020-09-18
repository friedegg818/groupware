package com.of.scheduler;

import java.util.List;
import java.util.Map;

public interface SchedulerService {
	public void insertScheduler(Scheduler scheduler) throws Exception;
	public List<Scheduler> listMonthSchedule(Map<String, Object> map);
	public Scheduler readScheduler(int schNum);
	public int updateScheduler(Scheduler scheduler) throws Exception;
	public void deleteScheduler(int schNum) throws Exception;
	
}
