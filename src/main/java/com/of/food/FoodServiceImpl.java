package com.of.food;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.of.common.dao.CommonDAO;

@Service
public class FoodServiceImpl implements FoodService {

	@Autowired
	private CommonDAO dao;
	
	@Override
	public void insertFood(Food dto) throws Exception {
		try {
			dao.insertData("food.insertFood", dto);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}

	@Override
	public List<Food> listFood(Map<String, Object> map) {
		List<Food> list = null;
		
		try {
			list=dao.selectList("food.listFood", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	@Override
	public List<Food> listDay(Map<String, Object> map) throws Exception {
		List<Food> listDay = null;
		
		try {
			listDay=dao.selectList("food.listDay", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listDay;
	}

	@Override
	public Food readFood(int foodNum) throws Exception {
		Food dto=null;
		try {
			dto=dao.selectOne("food.readFood", foodNum);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return dto;
	}

	@Override
	public void updateFood(Food dto) throws Exception {
		
		try {
			dao.updateData("food.updateFood", dto);			
		} catch (Exception e) {
			throw e;
		}
	}

	@Override
	public void deleteFood(Map<String, Object> map) throws Exception {
		try {
			dao.deleteData("food.deleteFood", map);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

}
