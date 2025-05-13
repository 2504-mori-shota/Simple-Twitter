package chapter6.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import chapter6.beans.Message;
import chapter6.logging.InitApplication;
import chapter6.servise.MessageService;

@WebServlet(urlPatterns = { "/edit" })
public class EditServlet extends HttpServlet {

    /**
    * ロガーインスタンスの生成
    */
    Logger log = Logger.getLogger("twitter");

    /**
    * デフォルトコンストラクタ
    * アプリケーションの初期化を実施する。
    */
    public EditServlet() {
        InitApplication application = InitApplication.getInstance();
        application.init();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

	  log.info(new Object(){}.getClass().getEnclosingClass().getName() +
        " : " + new Object(){}.getClass().getEnclosingMethod().getName());

	  HttpSession session = request.getSession();
	  List<String> errorMessages = new ArrayList<String>();

	  String strMessageId = request.getParameter("id");

	  if (!strMessageId.matches("^[0-9]+$") || StringUtils.isBlank(strMessageId)) {
    	  errorMessages.add("不正なパラメータが入力されました");
          session.setAttribute("errorMessages", errorMessages);
          response.sendRedirect("./");
          return;
	  }

	  Message messages = new MessageService().select(Integer.parseInt(strMessageId));

	  if (messages == null) {
		  errorMessages.add("不正なパラメータが入力されました");
	      session.setAttribute("errorMessages", errorMessages);
	      response.sendRedirect("./");
	       return;
	  }

		  request.setAttribute("messages", messages);
	      request.getRequestDispatcher("edit.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

	  log.info(new Object(){}.getClass().getEnclosingClass().getName() +
        " : " + new Object(){}.getClass().getEnclosingMethod().getName());

	  HttpSession session = request.getSession();
      List<String> errorMessages = new ArrayList<String>();

      String text = request.getParameter("text");
      if (!isValid(text, errorMessages)) {
          session.setAttribute("errorMessages", errorMessages);
          response.sendRedirect("edit.jsp");
          return;
      }

      Message message = new Message();
      message.setId(Integer.parseInt(request.getParameter("id")));
      message.setText(text);

      new MessageService().update(message);
      response.sendRedirect("./");
  }

  private boolean isValid(String text, List<String> errorMessages) {

	  log.info(new Object(){}.getClass().getEnclosingClass().getName() +
      " : " + new Object(){}.getClass().getEnclosingMethod().getName());

      if (StringUtils.isBlank(text)) {
          errorMessages.add("メッセージを入力してください");
      } else if (140 < text.length()) {
          errorMessages.add("140文字以下で入力してください");
      }
      if (errorMessages.size() != 0) {
          return false;
      }
      return true;
    }

}
