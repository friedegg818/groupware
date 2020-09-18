package com.of.food;

import java.util.List;
import java.util.Map;

public interface FoodService {
	public void insertFood(Food dto) throws Exception;
	
	public List<Food> listFood(Map<String, Object>map) throws Exception;
	public List<Food> listDay(Map<String, Object>map) throws Exception;
	
	public Food readFood(int foodNum) throws Exception;
	
	public void updateFood(Food dto) throws Exception;
	public void deleteFood(Map<String, Object> map) throws Exception;
}
