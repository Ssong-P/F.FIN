package com.ffin.service.qna.impl;

import com.ffin.common.Search;
import com.ffin.service.domain.Inquiry;
import com.ffin.service.domain.Report;
import com.ffin.service.qna.QnADao;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("qnADaoImpl")
public class QnADaoImpl implements QnADao {

    //Field
    @Autowired
    @Qualifier("sqlSessionTemplate")
    private SqlSession sqlSession;
    public void setSqlSession(SqlSession sqlSession){
        this.sqlSession = sqlSession;
    }

    //Constructor
    public QnADaoImpl() {
        System.out.println("QnADaoImpl.QnADaoImpl Default Constructor");
    }

    //Method
    @Override
    public void addReport(Report report) throws Exception {
        System.out.println("QnADaoImpl.addReport");
        sqlSession.insert("QnAMapper.addReport", report);
    }

    @Override
    public Report getReport(int reportNo) throws Exception {
        System.out.println("QnADaoImpl.getReport");
        return sqlSession.selectOne("QnAMapper.getReport",reportNo);
    }

    @Override
    public List<Report> getReportList(Search search) throws Exception {
        System.out.println("QnADaoImpl.getReportList");
        return sqlSession.selectList("QnAMapper.getReportList", search);
    }

    @Override
    public int getTotalCount(Search search) throws Exception {
        System.out.println("QnADaoImpl.getTotalCount");
        return sqlSession.selectOne("QnAMapper.getTotalCount", search);
    }

    @Override
    public void updateReport(Report report) throws Exception {
        System.out.println("QnADaoImpl.updateReport");
        sqlSession.update("QnAMapper.updateReport", report);
    }

    @Override
    public void updateReportProcStatus(Report report) throws Exception {
        System.out.println("QnADaoImpl.updateReportProcStatus");
        sqlSession.update("QnAMapper.updateReportProcStatus", report);
    }

    @Override
    public void addInquiry(Inquiry inquiry) throws Exception {
        System.out.println("QnADaoImpl.addInquiry");
        sqlSession.insert("QnAMapper.addInquiry", inquiry);
    }

    @Override
    public Inquiry getInquiry(int inquiryNo) throws Exception {
        System.out.println("QnADaoImpl.getInquiry");
        return sqlSession.selectOne("QnAMapper.getInquiry", inquiryNo);
    }


}