package com.of.food;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.of.employee.SessionInfo;

@Controller("food.foodController")
//@RequestMapping("/food/*")
public class FoodController {
	
	@Autowired
	private FoodService service;
	
	
	@RequestMapping(value="/food/month")
	public String month(
			@RequestParam(name="year", defaultValue="0") int year,
			@RequestParam(name="month", defaultValue="0") int month,
			@RequestParam(name="foodNum", defaultValue="0") int foodNum,
			HttpSession session,
			Model model
			) {
		try {
			//SessionInfo info=(SessionInfo)session.getAttribute("employee");
			
			Calendar cal=Calendar.getInstance();
			int y=cal.get(Calendar.YEAR);
			int m=cal.get(Calendar.MONTH)+1; // 0~11
			int todayYear=y;
			int todayMonth=m;
			int todayDate=cal.get(Calendar.DATE);
			
			if(year==0) {
				year=y;
			}
			if(month==0) {
				month=m;
			}
			
			// year년 month월 1일의 요일
			cal.set(year, month-1, 1);
			year=cal.get(Calendar.YEAR);
			month=cal.get(Calendar.MONTH)+1;
			int week=cal.get(Calendar.DAY_OF_WEEK);
			
			// 첫주의 year년도 month월 1일 이전 날짜
			Calendar scal=(Calendar)cal.clone();
			scal.add(Calendar.DATE, -(week-1));
			int syear=scal.get(Calendar.YEAR);
			int smonth=scal.get(Calendar.MONTH)+1;
			int sdate=scal.get(Calendar.DATE);
			
			// 마지막주의 year년도 month월 말일주의 토요일 날짜
			Calendar ecal=(Calendar)cal.clone();
			// year년도 month월 말일
			ecal.add(Calendar.DATE, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
			// year년도 month월 말일주의 토요일
			ecal.add(Calendar.DATE, 7-ecal.get(Calendar.DAY_OF_WEEK));
			int eyear=ecal.get(Calendar.YEAR);
			int emonth=ecal.get(Calendar.MONTH)+1;
			int edate=ecal.get(Calendar.DATE);

			// 스케쥴 가져오기
			String startDay=String.format("%04d%02d%02d", syear, smonth, sdate);
			String endDay=String.format("%04d%02d%02d", eyear, emonth, edate);
			Map<String, Object> map=new HashMap<>();
			map.put("startDay", startDay);
			map.put("endDay", endDay);
						
			List<Food> list=service.listFood(map);
			
/*			Food vo = null;
			if(foodNum!=0) {
				vo=service.readFood(foodNum);
			}
			if(vo==null&&list.size()>0) {
				vo=service.readFood(list.get(0).getFoodNum());
			}
			*/
			String s;
			String [][]days=new String[cal.getActualMaximum(Calendar.WEEK_OF_MONTH)][7];
			
			// 1일 앞의 전달 날짜 및 일정 출력
			// startDay만 처리하고 endDay는 처리하지 않음(반복도 처리하지않음)
			for(int i=1; i<week; i++) {
				s=String.format("%04d%02d%02d", syear, smonth, sdate);
				days[0][i-1]="<span class='textDate preMonthDate' data-date='"+s+"' >"+sdate+"</span>";
				
				for(Food dto:list) {
					int sd=Integer.parseInt(dto.getCreated().replaceAll("-", ""));
					int cn=Integer.parseInt(s);
					
					if(sd==cn) {
						days[0][i-1]+="<span class='foodSubject' data-date='"+s+"' data-num='"+dto.getFoodNum()+"' >"+dto.getSubject()+"</span>";
					} else if (sd>cn) {
						break;
					}
				}
				
				sdate++;
				
			}
						
			// year년도 month월 날짜 및 일정 출력
			int row, n=0;
						
			jump:
			for(row=0; row<days.length; row++) {
				for(int i=week-1; i<7; i++) {
					n++;
					s=String.format("%04d%02d%02d", year, month, n);
								
					if(i==0) {
						days[row][i]="<span class='textDate sundayDate' data-date='"+s+"' >"+n+"</span>";
					} else if(i==6) {
						days[row][i]="<span class='textDate saturdayDate' data-date='"+s+"' >"+n+"</span>";
					} else {
						days[row][i]="<span class='textDate nowDate' data-date='"+s+"' >"+n+"</span>";
					}
					
					for(Food dto:list) {
						int sd=Integer.parseInt(dto.getCreated().replaceAll("-", ""));
						int cn=Integer.parseInt(s);
						
						if(sd==cn) {
							days[row][i]+="<span class='foodSubject' data-date='"+s+"' data-num='"+dto.getFoodNum()+"' >"+dto.getSubject()+"</span>";
						} else if(sd>cn){
							break;
						}
					}
					
					if(n==cal.getActualMaximum(Calendar.DATE)) {
						week=i+1;
						break jump;
					}
				}
				week=1;
			}
						
			// year년도 month월 마지막 날짜 이후 일정 출력
			if(week!=7) {
				n=0;
				for(int i=week; i<7; i++) {
					n++;
					s=String.format("%04d%02d%02d", eyear, emonth, n);
					days[row][i]="<span class='textDate nextMonthDate' data-date='"+s+"' >"+n+"</span>";
					
					for(Food dto:list) {
						int sd=Integer.parseInt(dto.getCreated().replaceAll("-", ""));
						int cn=Integer.parseInt(s);
						
						if(sd==cn) {
							days[row][i]+="<span class='foodSubject' data-date='"+s+"' data-num='"+dto.getFoodNum()+"' >"+dto.getSubject()+"</span>";
						} else if(sd>cn) {
							break;
						}
					}				
				}
			}
						
			String today=String.format("%04d%02d%02d", todayYear, todayMonth, todayDate);
			map.put("day", today);
			List<Food> listDay =service.listDay(map);
			
			
			
/*			
			for(int i=0; i<days.length; i++) {
				for(int j=0; j<days[i].length; j++) {
					System.out.println(days[i][j]);
				}
				System.out.println("-----------------------");
			}
			*/
			model.addAttribute("year", year);
			model.addAttribute("month", month);
			model.addAttribute("todayYear", todayYear);
			model.addAttribute("todayMonth", todayMonth);
			model.addAttribute("todayDate", todayDate);
			model.addAttribute("today", today);
			model.addAttribute("days", days);
			model.addAttribute("list", listDay);

						
		} catch (Exception e) {
			e.printStackTrace();
		}
					
		return ".food.month";
		
	}
	
	@RequestMapping(value="/food/day")
	@ResponseBody
	public Map<String, Object> listDay(
			@RequestParam String day
			)throws Exception{
		

		Map<String, Object> map = new HashMap<>();
		map.put("day", day);
		
		List<Food> listDay =service.listDay(map);
		
		Map<String, Object> model = new HashMap<>();
		model.put("listDay", listDay);
		
		return model;
	}
	
	@RequestMapping(value="/food/insert", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertSubmit(
			Food dto,
			HttpSession session
			){
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="false";
		try {
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
			dto.setWriter(info.getEmpNo());
			service.insertFood(dto);
			state="true";
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		
		
		return model;
	}
	
	@RequestMapping(value="/food/listDate")
	public String readFood(
			@RequestParam String selectDate,
			Model model
			)throws Exception{
		
		try {
			Map<String, Object> map=new HashMap<>();
			map.put("day", selectDate);
			List<Food> list=service.listDay(map);
			
			model.addAttribute("list", list);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "food/listDate";
	}
	
	
	
	@RequestMapping(value="/food/update", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSubmit(Food dto,
			HttpSession session) {
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="true";
		try {
			dto.setWriter(info.getEmpNo());
			service.updateFood(dto);
		} catch (Exception e) {
			state="false";
		}
		
		Map<String, Object> model=new HashMap<>();
		model.put("state", state);
		return model;
	}
	
	@RequestMapping(value="/food/delete")
	public String delete(
			@RequestParam int foodNum,
			HttpSession session
			) {
		SessionInfo info=(SessionInfo)session.getAttribute("employee");

		try {
			Map<String, Object> map=new HashMap<>();
			map.put("writer", info.getEmpNo());
			map.put("foodNum", foodNum);
			service.deleteFood(map);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/food/month";
	}
	

	
}


/*	public Map<String, Object> list(
			@RequestParam(value="pageNo", defaultValue="1") int current_page
			) throws Exception{
		int rows=5;
		int dataCount=service.dataCount();
		int total_page=myUtil.pageCount(rows, dataCount);
		if(current_page>total_page) {
			current_page=total_page;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		int offset = (current_page-1)*rows;
		if(offset<0) offset=0;
		map.put("offset", offset);
		map.put("rows", rows);
		
		List<Food> list = service.listFood(map);
		for(Food dto:list) {
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		}
		
		Map<String , Object> model= new HashMap<>();
		
		model.put("total_page", total_page);
		model.put("dataCount", dataCount);
		model.put("pageNo", current_page);
		model.put("list", list);
		
		return model;
	}
	
	@RequestMapping(value="insert", method=RequestMethod.POST)
	public Map<String , Object> createdSubmit(
			Food dto,
			HttpSession session
			) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="true";
		try {
			dto.setWriter(info.getEmpNo());
			service.insertFood(dto);
		} catch (Exception e) {
			state="false";
		}
		
		Map<String, Object> model=new HashMap<>();
		model.put("state", state);
		return model;
	}
	
	@RequestMapping(value="delete", method=RequestMethod.POST)
	public Map<String, Object> foodDelete(
			@RequestParam int foodNum,
			HttpSession session
			) throws Exception {
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="true";
		try {
			Map<String, Object> map=new HashMap<>();
			map.put("foodNum", foodNum);
			map.put("writer", info.getEmpNo());
			service.deleteFood(map);
		} catch (Exception e) {
			state="false";
		}			
		
		Map<String, Object> model=new HashMap<>();
		model.put("state", state);
		return model;
	}
}
*/