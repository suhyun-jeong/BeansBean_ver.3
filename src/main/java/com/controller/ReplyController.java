package com.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.service.ReplyService;

@Controller
public class ReplyController {
	
	@Autowired
	ReplyService replyService;

}
