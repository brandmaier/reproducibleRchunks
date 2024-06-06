library(hexSticker)
img <- "https://uxwing.com/wp-content/themes/uxwing/download/signs-and-symbols/finger-print-icon.png"
s <- hexSticker::sticker(subplot=img, s_x=0.97,
                         package = "reproducibleRchunks",
                         filename="inst/img/sticker.png",
                         p_color="black",u_color = "white",p_size = 12,
                         h_fill="white", h_color="black")
plot(s)
