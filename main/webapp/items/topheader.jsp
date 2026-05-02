<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%
    Usuario _thUser = (Usuario) session.getAttribute("usuarioLogeado");
    if (_thUser == null) { response.sendRedirect("Login.jsp"); return; }
    String _thNombre   = _thUser.getNombre()   != null ? _thUser.getNombre()   : "";
    String _thApellido = _thUser.getApellido() != null ? _thUser.getApellido() : "";
    String _thTitle    = (String) request.getAttribute("pageTitle");
    String _thSub      = (String) request.getAttribute("pageSubtitle");
    String _thAction   = (String) request.getAttribute("headerActionHtml");
    if (_thTitle == null) _thTitle = "Panel";
    if (_thSub   == null) _thSub   = "";
    if (_thAction == null) _thAction = "";
%>
<header class="top-header">
    <button class="sidebar-toggle" id="sidebar-toggle" title="Expandir/colapsar menú">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none"
             stroke="#0284C7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="3" x2="21" y1="6" y2="6"/>
            <line x1="3" x2="21" y1="12" y2="12"/>
            <line x1="3" x2="21" y1="18" y2="18"/>
        </svg>
    </button>
    <div class="header-welcome">
        <h1 class="header-page-title"><%= _thTitle %></h1>
        <% if (!_thSub.isEmpty()) { %>
            <p class="header-page-sub"><%= _thSub %></p>
        <% } %>
    </div>
    <div class="header-actions">
        <%= _thAction %>
        <span class="header-greeting">Bienvenido, <strong class="highlight-name"><%= _thNombre %> <%= _thApellido %></strong></span>
        <!-- Puente oculto para compatibilidad con gestionPac.js -->
        <button id="btn_editar_usuario" style="display:none" onclick="openPerfilPopup()"></button>
    </div>
</header>
