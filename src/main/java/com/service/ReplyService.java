package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.ReplyDAO;

@Service
public class ReplyService {
	@Autowired
	ReplyDAO dao;
}
