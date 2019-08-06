<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="h" uri="/hanweb-tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>调查征集系统</title>
<h:head cookie="true" dialog="true" message="true" iconfont="true" menu="true" tree="true" toggle="true"></h:head>
<h:import type="js" path="/ui/script/ui.js"></h:import>
<link type="text/css" rel="stylesheet" href="${contextPath}/resources/dczj/layui/css/layui.css">
<script src="${contextPath}/resources/dczj/layui/layui.js"></script>
<script type="text/javascript">
$(function(){
	var treeMenu = ${tree};
    $('#webtree').menu({
		tree : 'rangemenu',
		height : 200,
		init : function() {
			setting('rangemenu', onClickRange, onDbClickRange, treeMenu);
		}
	});
   
	function onClickRange(event, treeId, treeNode) {
		$.ajax({
			type : "post",
			url : "../manager/dczj/setwebidsession.do",
			data : {
				"webid" : treeNode.id
			},
			cache : false,
			success : function(result) {
				if (result.success) {
					$('#webid').val(treeNode.id);
					$('#webtree').val(treeNode.name);
					$('#webtree_menu').fadeOut(50);
				} else {
					alert("请联系管理员");
				}
			}
		})
	}
	function setting(treeName, onClickFunction, onDblClickFunction, rootNode) {
		var setting = {
			async : {
				enable : true,
				url : '${contextPath}/manager/quesbank/menuwithurlforuser_search.do',
				autoParam : [ "id=webid", "isDisabled" ]
			},
			callback : {
				beforeClick : beforeClick,
				beforeDblClick : beforeClick,
				onClick : onClickFunction,
				onDblClick : onDblClickFunction
			}
		};
		$("#" + treeName).tree(setting, rootNode);
		$("#" + treeName).tree().refreshNode('');
	}
	function onDbClickRange(event, treeId, treeNode) {
		if (treeNode == null) {
			return;
		}
		if (treeNode.isDisabled)//根节点及失效节点双击无效
			return;
		$('#webid').val(treeNode.id);
		$('#webtree').val(treeNode.name);
	}
	function beforeClick(treeId, treeNode, clickFlag) {
		if (treeNode.isDisabled)
			return false;
		return (treeNode.id != 0);
	}
});
function sysManager(){
	window.location.href = "${contextPath}/manager/system/list.do";
}

function closeTree(){
	$('#webtree_menu').fadeOut(50);
}

function backhomepage(){
	window.history.go(-1);
}

//到时候绑定count
layui.use(['laypage', 'layer'], function(){
	  var laypage = layui.laypage
	  ,layer = layui.layer;
	laypage.render({
    elem: 'page'
    ,count: 100
    ,layout: ['count', 'prev', 'page', 'next', 'limit', 'refresh', 'skip']
    ,jump: function(obj){
      console.log(obj)
    }
  });
});
</script>

</head>

<body class="layui-layout-body" >
	 <input type="hidden" id="webid" name="webid">
    <input type="hidden" id="webname" name="webname">
<%-- 	<div class="layui-layout layui-layout-admin">
	  <div class="layui-header layui-bg-main">
	    <div class="layui-logo layui-bg-main" style="width:200px;">
	    	<span id="logo" style="font-size:18px;"><font color="#5CB85C"><b>JSURVEY</b></font></span>
	    	<span style="font-size:16px;"><font color="#eeeeee"><b>调查征集系统 </b></font></span>
	    </div>
	    <!-- 头部区域（可配合layui已有的水平导航） -->
	    <ul class="layui-nav layui-layout-left layui-bg-main">
	    	<li class="layui-nav-item"><a href="../index.do">我的调查</a></li>
	    	<li class="layui-nav-item"><a href="../QuesBank.do">测评题库</a></li>
	    </ul>
	    <ul class="layui-nav layui-layout-right layui-bg-main">
	      <li class="layui-inline" style="padding-right: 20px;">
	      	<input type="text" id="webtree" class="layui-input" style="width: 200px;" readonly = "readonly" value="${webname}">
	      </li>
	      <c:if test="${isSysManager==1}">
	      	 <li class="layui-inline" onclick="sysManager();" style="width: 60px;cursor: pointer;"><img alt="系统设置" width="30px;" src="${contextPath}/resources/dczj/images/u10.png"></li>
	      </c:if>
	     
	      <li class="layui-nav-item">
	        <a href="javascript:;">您好，${user.name}</a>
	        <dl class="layui-nav-child">         
	          <dd><a style="cursor: pointer;" onclick="openDialog('${contextPath}/manager/user/modify_self_show.do',500,515,{title:'账户设置'})">账户设置</a></dd>
	          <dd><a style="cursor: pointer;" onclick="openDialog('${contextPath}/manager/onlineuser/list.do',500,515,{title:'在线用户'})">在线用户</a></dd>
	          <dd><a style="cursor: pointer;" onclick="top.location.href='${contextPath}/logout.do'">系统退出</a></dd>
	        </dl>
	      </li>
	    </ul>
	  </div>
	</div> --%>
	<div class="layui-body" style="top:60px;left:0px;">  
		<div  align="right" style="height: 40px">
			<img alt="返回" src="../../resources/dczj/images/u2080.png" style="width: 30px; margin-top:10px; margin-right: 20px; cursor: pointer;"onclick="backhomepage(webid);">
	 	</div> 
	 	<!--卡片面板-  -->
			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
			  <legend>绑定题库名称</legend>
			</fieldset>   
			 
			<div style="padding: 20px; background-color: #F2F2F2;">
				<div class="layui-row layui-col-space15">
				<div class="layui-col-md6">
				<!-- 点击新增分类 动态增加小div面板  -->
			      <button  type="button"  style="width: 300px;height: 111px;background-color: #F2F2F2;
			      		border-top-width: 1px;border-bottom-width: 1px;border-left-width: 1px;border-right-width: 1px;
			      		border-color: #C0C0C0;
			      		">
						+新增分类
   				 </button>
   				</div>
			  </div>
			</div> 
			
			<!-- 底部分页 -->
		<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;"></fieldset>		 	
	 	<div id="page"></div>
	</div>
	<script src="${contextPath}/resources/dczj/js/quesbankpage.js"></script>
	<script src="${contextPath}/resources/dczj/js/quesbank.js"></script>
	
</body>
<script>

layui.use('element', function(){
  var element = layui.element;

});
</script>
</html>