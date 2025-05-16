<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ArrayList<?> daftarFilmObj = (ArrayList<?>) session.getAttribute("daftarFilm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Form Pemesanan Tiket</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <style>
        body {
            background-image: url('image/3.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-container {
            background-color: rgba(0, 0, 0, 0.75); /* Tanpa blur */
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.7);
            animation: fadeInUp 1s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-label {
            font-weight: bold;
        }

        .btn-success {
            background-color: #ffcc00;
            border: none;
            color: #000;
            font-weight: bold;
            transition: background-color 0.3s, transform 0.2s;
        }

        .btn-success:hover {
            background-color: #e6b800;
            transform: scale(1.05);
        }

        .form-select, .form-control {
            background-color: #2c2c2c;
            color: #fff;
            border: 1px solid #444;
        }

        .form-select:focus, .form-control:focus {
            border-color: #ffcc00;
            box-shadow: none;
        }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
    <div class="form-container w-100" style="max-width: 600px;">
        <h2 class="text-center mb-4">Form Pemesanan Tiket</h2>
        <form action="struk.jsp" method="post">
            <div class="mb-3">
                <label for="nama" class="form-label">Nama Pemesan:</label>
                <input type="text" name="nama" id="nama" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="jumlah" class="form-label">Jumlah Tiket:</label>
                <input type="number" name="jumlah" id="jumlah" class="form-control" min="1" required>
            </div>

            <div class="mb-3">
                <label for="film" class="form-label">Pilih Film:</label>
                <select name="film" id="film" class="form-select" required onchange="updateJamTayang()">
                    <%
                        for (Object obj : daftarFilmObj) {
                            java.lang.reflect.Field judulField = obj.getClass().getDeclaredField("judul");
                            judulField.setAccessible(true);
                            String judul = (String) judulField.get(obj);
                    %>
                        <option value="<%= judul %>"><%= judul %></option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div class="mb-3">
                <label for="jam" class="form-label">Pilih Jam Tayang:</label>
                <select name="jam" id="jam" class="form-select" required></select>
            </div>

            <button type="submit" class="btn btn-success w-100">Pesan Tiket</button>
        </form>
    </div>
</div>

<script>
    const dataJamTayang = {
        <% for (Object obj : daftarFilmObj) {
            java.lang.reflect.Field judulField = obj.getClass().getDeclaredField("judul");
            judulField.setAccessible(true);
            String judul = (String) judulField.get(obj);

            java.lang.reflect.Field jamField = obj.getClass().getDeclaredField("jamTayang");
            jamField.setAccessible(true);
            String[] jamTayang = (String[]) jamField.get(obj);
        %>
        "<%= judul %>": [<%
            for (int i = 0; i < jamTayang.length; i++) {
                out.print("\"" + jamTayang[i] + "\"");
                if (i < jamTayang.length - 1) out.print(",");
            }
        %>],
        <% } %>
    };

    function updateJamTayang() {
        const filmSelect = document.getElementById("film");
        const jamSelect = document.getElementById("jam");
        const selectedFilm = filmSelect.value;

        const jamList = dataJamTayang[selectedFilm] || [];

        jamSelect.innerHTML = "";

        jamList.forEach(jam => {
            const option = document.createElement("option");
            option.value = jam;
            option.text = jam;
            jamSelect.appendChild(option);
        });
    }

    document.addEventListener("DOMContentLoaded", updateJamTayang);
</script>

</body>
</html>
