{% set has_video = settings.video_embed %}

{% if settings.home_order_position_1 == 'video' and has_video %}
	{% if "video_image.jpg" | has_custom_image %}
		{% set video_image_src = 'video_image.jpg' | static_url | settings_image_url("original") %}
	{% else %}
		<link rel="preconnect" href="https://img.youtube.com/" />
		{% set video_url = settings.video_embed %}
		{% set video_format = 
			'/watch?v=' in video_url ? '/watch?v=' :
			'/youtu.be/' in video_url ? '/youtu.be/' :
			'/shorts/' in video_url ? '/shorts/'
		%}
		{% set video_id = video_url|split(video_format)|last %}
		{% set video_image_src = 'https://img.youtube.com/vi_webp/' ~ video_id ~ '/maxresdefault.webp' %}
	{% endif %}
	<link rel="preload" as="image" href="{{ video_image_src }}"{% if "video_image.jpg" | has_custom_image %} imagesrcset="{{ 'video_image.jpg' | static_url | settings_image_url('large') }} 480w, {{ 'video_image.jpg' | static_url | settings_image_url('huge') }} 640w, {{ 'video_image.jpg' | static_url | settings_image_url('original') }} 1024w"{% endif %}>
{% endif %}
