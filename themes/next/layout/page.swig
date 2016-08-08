{% extends '_layout.swig' %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}
  {% set page_title_suffix = ' | ' + config.title %}

  {% if page.type === "categories" %}
    {{ __('title.category') + page_title_suffix }}
  {% elif page.type === "tags" %}
    {{ __('title.tag') + page_title_suffix }}
  {% else %}
    {{ page.title + page_title_suffix }}
  {% endif %}
{% endblock %}

{% block content %}

  <div id="posts" class="posts-expand">
    {# tagcloud page support #}
    {% if page.type === "tags" %}
      <div class="tag-cloud">
        <div class="tag-cloud-title">
            {{ _p('counter.tag_cloud', site.tags.length) }}
        </div>
        <div class="tag-cloud-tags">
          {{ tagcloud({min_font: 12, max_font: 30, amount: 200, color: true, start_color: '#ccc', end_color: '#111'}) }}
        </div>
      </div>
    {% elif page.type === 'categories' %}
      <div class="category-all-page">
        <div class="category-all-title">
            {{ _p('counter.categories', site.categories.length) }}
        </div>
        <div class="category-all">
          {{ list_categories() }}
        </div>
      </div>	
    {% else %}
      {{ page.content }}
	  {% if page.type === 'guestbook' %}
		{% if theme.chatbox.enable %}
			{% include '_scripts/chatbox.swig' %}
			<div class="socketchatbox-page">
				<div id="socketchatbox-nw" class="socketchatbox-resize"></div>
				<div id="socketchatbox-ne" class="socketchatbox-resize"></div>
				<div id='socketchatbox-top'>
					<div id='socketchatbox-username'></div>
					<div id='socketchatbox-closeChatbox'>x</div>
					<div id='socketchatbox-showHideChatbox'>↓</div>
				</div>
				<div id='socketchatbox-body'>
					<div class="socketchatbox-chatArea">
						<ul class="socketchatbox-messages"></ul>
					</div>
					<form id="socketchatbox-sendMedia">
						<div>
							<label class="socketchatbox-filebutton">
								Drop file above to send or click here
								<input type="file" id="socketchatbox-imagefile" accept="image/*">
							</label>
						</div>
					</form>       
					<input class="socketchatbox-inputMessage" placeholder="Type here..."/>
				</div>
			</div>
		{% endif %}
	  {% endif %}
	  {% if page.type === 'about' %}
		{% if theme.baidu_map.enable %}
			<blockquote class="blockquote-center"><div id="map" style="height:350px;"></div></blockquote>
			{% include '_scripts/baidu-map.swig' %}
		{% endif %}
	  {% endif %}
    {% endif %}
  </div>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}
