package com.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.bind.ParseConversionEvent;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dto.Cook_BrdDTO;
import com.dto.Info_BrdDTO;
import com.dto.IngrementDTO;
import com.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	BoardService service;

	@RequestMapping("/Info_BRD")
	public ModelAndView Info_BRD_list() {
		List<Info_BrdDTO> list = service.Info_BRD_list();
		ModelAndView mav = new ModelAndView();
		mav.addObject("Info", list);
		mav.setViewName("/Info_BRD");
		return mav;
	}

	@RequestMapping(value = "/Info_BRD_write", method = RequestMethod.GET)
	public String Info_BRD_write() {
		return "Info_BRD_write";
	}

	@RequestMapping(value = "/Info_BRD_insert", method = RequestMethod.POST)
	public String Info_BRD_insert(@ModelAttribute Info_BrdDTO info) {
		service.Info_BRD_insert(info);
		return "redirect:/Info_BRD";
	}

	@RequestMapping("/Info_BRD_DetailView")
	@ModelAttribute("Info_BRD_DetailView")
	public ModelAndView Info_BRD_DetailView(int num) {
		ModelAndView mav = new ModelAndView();
		Info_BrdDTO dto = service.Info_BRD_DetailView(num);
		mav.addObject("dto", dto);
		return mav;
	}

	@RequestMapping(value = "Info_BRD_delete")
	public String Info_BRD_delete(int num) {
		service.Info_BRD_delete(num);
		return "redirect:/Info_BRD"; //삭제후 글 목록으로 이동.
	}
	
	@RequestMapping("/Cook_BRD")
	public ModelAndView Cook_BRD_list() {
		List<Cook_BrdDTO> list = service.Cook_BRD_list();
		ModelAndView mav = new ModelAndView();
		mav.addObject("Cook", list);
		return mav;
	}

	@RequestMapping(value = "/Cook_BRD_write", method = RequestMethod.GET)
	public String Cook_BRD_write() {
		return "Cook_BRD_write";
	}

	@ResponseBody
	@RequestMapping(value = "/Cook_BRD_insert", method = RequestMethod.POST)
	public void Cook_BRD_insert(@ModelAttribute Cook_BrdDTO cook) {
		service.Cook_BRD_insert(cook);
	}

	@ResponseBody
	@RequestMapping(value = "ingrementInsert", method = RequestMethod.GET)
	public void ingrementInsert(IngrementDTO ingre) {
		int num = service.CookNumGet();
		ingre.setNum(num);
		service.ingrementInsert(ingre);

	}

	@RequestMapping("/Cook_BRD_DetailView")
	@ModelAttribute("Cook_BRD_DetailView")
	public ModelAndView Cook_BRD_DetailView(int num) {
		ModelAndView mav = new ModelAndView();
		Cook_BrdDTO dto = service.Cook_BRD_DetailView(num);
		List<IngrementDTO> iList = service.Ingrement_List(num);
		mav.addObject("iList", iList);
		mav.addObject("dto", dto);
		return mav;
	}
	
	@RequestMapping(value= "Cook_BRD_update", method = RequestMethod.GET)
	public ModelAndView Cook_BRD_update(int num) {
		//래시피게시판 수정창에 옵션을 보여주는 기능.
		Cook_BrdDTO cdto = service.Cook_BRD_DetailView(num);
		List<IngrementDTO> iList = service.Ingrement_List(num);
		ModelAndView mav = new ModelAndView();
		mav.addObject("cdto", cdto);
		mav.addObject("iList", iList);
		mav.setViewName("Cook_BRD_update");
		return mav;
	}
	
	@RequestMapping(value= "Info_BRD_update", method = RequestMethod.GET)
	public ModelAndView Info_BRD_update(int num) {
		//사업자 게시판 수정창에 옵션을 보여주는 기능.
		Info_BrdDTO idto = service.Info_BRD_DetailView(num);
		ModelAndView mav = new ModelAndView();
		mav.addObject("idto", idto);
		mav.setViewName("Info_BRD_update");
		return mav;
	}
	
	@ResponseBody
	@RequestMapping(value = "/Info_BRD_modify", method = RequestMethod.POST)
	public void Info_BRD_modify(@ModelAttribute Info_BrdDTO Info) {
		//사업자 게시판 수정하기 기능.
		System.out.println(Info.getNum());
		service.Info_BRD_modify(Info);
	}
	
	
	
	
	@RequestMapping(value = "Cook_BRD_delete")
	public String Cook_BRD_delete(int num) {
		service.Cook_BRD_delete(num);
		return "redirect:/Cook_BRD"; //삭제후 글 목록으로 이동.
	}
	
	@ResponseBody
	@RequestMapping(value = "/Cook_BRD_modify", method = RequestMethod.POST)
	public void Cook_BRD_modify(@ModelAttribute Cook_BrdDTO cook) {
		//래시피 게시판 수정하기 기능.
		service.Cook_BRD_modify(cook);
	}

	@ResponseBody
	@RequestMapping(value = "/ingrementModify", method = RequestMethod.GET)
	public void ingrementModify(IngrementDTO ingre) {
		int num =ingre.getNum();
		service.ingrementInsert(ingre);
	}
	
	@ResponseBody	
	@RequestMapping(value = "ingredel")
	public void ingredel(int num) {
		service.ingrementDelete(num);
	}
	

}
