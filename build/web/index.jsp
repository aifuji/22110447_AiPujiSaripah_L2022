<%@ page import="java.util.ArrayList, java.text.NumberFormat, java.util.Locale" %> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    class Film {
        String judul, genre, durasi, posterUrl;
        int harga;
        String[] jamTayang;

        Film(String judul, String genre, String durasi, int harga, String[] jamTayang, String posterUrl) {
            this.judul = judul;
            this.genre = genre;
            this.durasi = durasi;
            this.harga = harga;
            this.jamTayang = jamTayang;
            this.posterUrl = posterUrl;
        }
    }

    ArrayList<Film> daftarFilm = new ArrayList<Film>();
    daftarFilm.add(new Film("Avengers: Endgame", "Action", "3 Jam", 50000,
        new String[]{"13:00", "16:00", "19:00"},
        "https://m.media-amazon.com/images/I/81ExhpBEbHL._AC_SY679_.jpg"));

    daftarFilm.add(new Film("Coco", "Animation", "1.5 Jam", 40000,
        new String[]{"11:00", "14:00", "17:00"},
        "https://m.media-amazon.com/images/I/816nLlJ-weL._AC_SY879_.jpg"));

    daftarFilm.add(new Film("Inception", "Sci-Fi", "2.5 Jam", 55000,
        new String[]{"12:00", "15:00", "18:00"},
        "https://cdn.shopify.com/s/files/1/1416/8662/products/inception_2010_imax_original_film_art_2000x.jpg?v=1551890318"));

    session.setAttribute("daftarFilm", daftarFilm);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Daftar Film</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Animasi -->
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css" />
    <style>
        body {
            margin: 0;
            padding: 0;
            background-image: url('image/3.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            min-height: 100vh;
            position: relative;
            color: #fff;
            font-family: 'Segoe UI', sans-serif;
        }

        .content {
            position: relative;
            z-index: 2;
        }

        .hover-shadow {
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }

        .hover-shadow:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.6);
            transform: scale(1.03);
        }

        .beli-tiket-btn {
            background-color: #ffcc00;
            color: #000;
            font-weight: bold;
            border: none;
            width: 100%;
            padding: 10px;
            border-radius: 0 0 6px 6px;
        }

        .beli-tiket-btn:hover {
            background-color: #e6b800;
        }

        h2 {
            font-weight: bold;
            text-shadow: 0 2px 4px rgba(0,0,0,0.8);
        }
    </style>
</head>
<body>

<div class="container mt-5 content">
    <h2 class="text-center mb-4" data-aos="fade-down">DAFTAR FILM BIOSKOP</h2>

    <div class="row row-cols-1 row-cols-md-3 g-4">
        <%
            NumberFormat rupiahFormat = NumberFormat.getCurrencyInstance(new Locale("in", "ID"));
            for (Film f : daftarFilm) {
                String hargaFormatted = rupiahFormat.format(f.harga).replace(",00", "");
        %>
        <div class="col" data-aos="fade-up">
            <div class="card h-100 bg-light text-dark shadow-sm">
                <img src="<%= f.posterUrl %>" class="card-img-top hover-shadow"
                     alt="Poster <%= f.judul %>"
                     style="width: 100%; height: 400px; object-fit: contain; background-color: #000; border-radius: 6px 6px 0 0;">
                <form action="formPesan.jsp" method="get">
                    <input type="hidden" name="judul" value="<%= f.judul %>">
                    <input type="hidden" name="harga" value="<%= f.harga %>">
                    <button type="submit" class="beli-tiket-btn">BELI TIKET</button>
                </form>
                <div class="card-body">
                    <h5 class="card-title text-center"><%= f.judul %></h5>
                    <p class="card-text">
                        <strong>Genre:</strong> <%= f.genre %><br>
                        <strong>Durasi:</strong> <%= f.durasi %><br>
                        <strong>Harga:</strong> <%= hargaFormatted %><br>
                        <strong>Jam Tayang:</strong>
                        <%
                            for (String jam : f.jamTayang) {
                                out.print(jam + " ");
                            }
                        %>
                    </p>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>

<!-- JS untuk animasi -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({
        duration: 1000,
        once: true
    });
</script>

</body>
</html>
