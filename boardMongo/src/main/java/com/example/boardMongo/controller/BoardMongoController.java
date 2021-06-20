package com.example.boardMongo.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class BoardMongoController {
	
	@Autowired
	private Environment env;
	
	@Autowired
	private MongoTemplate mongoTemplate;
	
	@Autowired
	private BoardRepository boardRepository;

	@RequestMapping("/board.do")
	public String board() throws Exception{
		System.out.println("board.do");
		return "/board";
	}
	@RequestMapping("/list.do")
	@ResponseBody
	public Map<String, Object> list() throws Exception{
		System.out.println("list.do====");
		Map<String, Object> map = new HashMap<String, Object>();
		List<Board> list = new ArrayList<Board>();
		
		list = boardRepository.findAll();
		
		map.put("list", list); 
		
		return map;
	}
	@RequestMapping(value = "/add.do", method = RequestMethod.POST) // POST로만 받겠다.
	@ResponseBody
	public Map<String, Object> add(@RequestParam(value="title", required = true) String title,
			@RequestParam(value="content", required = false, defaultValue = "") String contents) throws Exception{
		System.out.println("add.do====");
		Map<String, Object> map = new HashMap<>();
		
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd hh:MM");
		Date time = new Date();
		String ymd = format1.format(time);
		
		try {	
			Query query = new Query();
			Board in = new Board();
			in.setTitle(title);
			in.setContents(contents);
			in.setDate(ymd);
	
			boardRepository.insert(in);  // MongoDB에 들어감
			System.out.println(in.getTitle() + "===" + in.getContents() + "===" + ymd);
			map.put("returnCode", "success");
			map.put("returnDesc", "데이터가 정상적으로 등록되었습니다."); 
			
		} catch (Exception e) {
			map.put("returnCode", "failed");
			map.put("returnDesc", "데이터 등록에 실패하였습니다.");
		}
		return map;
	}
	@RequestMapping(value = "/mod.do", method = RequestMethod.POST) // POST로만 받겠다.
	@ResponseBody
	public Map<String, Object> mod(
			@RequestParam(value="id", required = true) String id,
			@RequestParam(value="title", required = true) String title,
			@RequestParam(value="content", required = false, defaultValue = "") String contents) throws Exception{
		System.out.println("mod.do====");
		Map<String, Object> map = new HashMap<>();
		
		try {	
			Query query = new Query();
			Criteria activityCriteria = Criteria.where("id").is(id);
			query.addCriteria(activityCriteria);
			List<Board> out = mongoTemplate.find(query, Board.class);
			
			if(out.size() > 0) {
				Board in = out.get(0);
				in.setTitle(title);
				in.setContents(contents);
				boardRepository.save(in);  // MongoDB에 들어감
			}
			map.put("returnCode", "success");
			map.put("returnDesc", "데이터가 정상적으로 수정되었습니다."); 
			
		} catch (Exception e) {
			map.put("returnCode", "failed");
			map.put("returnDesc", "데이터 수정에 실패하였습니다.");
		}
		return map;
	}
	
	@RequestMapping(value = "/del.do", method = RequestMethod.POST) // POST로만 받겠다.
	@ResponseBody
	public Map<String, Object> del(
			@RequestParam(value="id", required = true) String id) throws Exception{
		System.out.println("del.do====");
		Map<String, Object> map = new HashMap<>();
		
		try {	
			Query query = new Query();
			Criteria activityCriteria = Criteria.where("id").is(id);
			query.addCriteria(activityCriteria);
			List<Board> out = mongoTemplate.find(query, Board.class);
			
			if(out.size() > 0) {
				Board in = out.get(0);
				boardRepository.delete(in);  // MongoDB에 들어감
			}
			map.put("returnCode", "success");
			map.put("returnDesc", "데이터가 정상적으로 삭제되었습니다."); 
			
		} catch (Exception e) {
			map.put("returnCode", "failed");
			map.put("returnDesc", "데이터 삭제에 실패하였습니다.");
		}
		return map;
	}
}
