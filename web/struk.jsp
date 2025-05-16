<%@ page import="java.util.*, java.text.*" %> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String nama = request.getParameter("nama");
    String jumlahStr = request.getParameter("jumlah");
    String filmDipilih = request.getParameter("film");
    String jamTayang = request.getParameter("jam");

    int jumlahTiket = Integer.parseInt(jumlahStr);
    int hargaTiket = 0;

    ArrayList<?> daftarFilm = (ArrayList<?>) session.getAttribute("daftarFilm");

    for (Object obj : daftarFilm) {
        java.lang.reflect.Field judulField = obj.getClass().getDeclaredField("judul");
        judulField.setAccessible(true);
        String judul = (String) judulField.get(obj);

        if (judul.equals(filmDipilih)) {
            java.lang.reflect.Field hargaField = obj.getClass().getDeclaredField("harga");
            hargaField.setAccessible(true);
            hargaTiket = hargaField.getInt(obj);
            break;
        }
    }

    int totalHarga = jumlahTiket * hargaTiket;
    String tanggalSekarang = new SimpleDateFormat("dd-MM-yyyy HH:mm").format(new Date());

    // Format harga
    NumberFormat formatter = NumberFormat.getInstance(new Locale("id", "ID"));
    String hargaTiketFormatted = "Rp " + formatter.format(hargaTiket);
    String totalHargaFormatted = "Rp " + formatter.format(totalHarga);

    // Nomor Transaksi otomatis
    String noTransaksi = "TRX" + System.currentTimeMillis();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Struk Pemesanan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/qrcode/build/qrcode.min.js"></script>
    <style>
        body {
            background-image: url('image/3.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            font-family: 'Courier New', Courier, monospace;
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .struk-container {
            background-color: rgba(0,0,0,0.85);
            padding: 30px;
            border-radius: 12px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 0 20px rgba(0,0,0,0.6);
        }
        .struk-container h2 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .struk-container p {
            font-size: 16px;
            margin-bottom: 5px;
        }
        .btn-group {
            margin-top: 20px;
        }
        canvas {
            display: block;
            margin: 15px auto 0 auto;
        }
    </style>
</head>
<body>

<div class="struk-container" id="struk">
    <h2>🎟️ STRUK PEMESANAN TIKET 🎟️</h2>
    <p><strong>No. Transaksi:</strong> <%= noTransaksi %></p>
    <p><strong>Nama:</strong> <%= nama %></p>
    <p><strong>Film:</strong> <%= filmDipilih %></p>
    <p><strong>Jam Tayang:</strong> <%= jamTayang %></p>
    <p><strong>Jumlah Tiket:</strong> <%= jumlahTiket %></p>
    <p><strong>Harga per Tiket:</strong> <%= hargaTiketFormatted %></p>
    <p><strong>Total Harga:</strong> <%= totalHargaFormatted %></p>
    <p><strong>Tanggal:</strong> <%= tanggalSekarang %></p>

    <canvas id="qrCodeCanvas" width="180" height="180"></canvas>

    <div class="btn-group d-grid gap-2">
        <a href="index.jsp" class="btn btn-primary">Kembali ke Halaman Utama</a>
        <button onclick="window.print()" class="btn btn-secondary">Cetak Struk</button>
        <button id="downloadPDF" class="btn btn-success">Unduh sebagai PDF</button>
    </div>
</div>

<script>
    // QR Code
    const qrData = `No.Transaksi: <%= noTransaksi %>\nNama: <%= nama %>\nFilm: <%= filmDipilih %>\nJam: <%= jamTayang %>\nJumlah: <%= jumlahTiket %>\nTotal: <%= totalHargaFormatted %>`;
    QRCode.toCanvas(document.getElementById("qrCodeCanvas"), qrData, function (error) {
        if (error) console.error(error);
    });

    // PDF Export
    document.getElementById("downloadPDF").addEventListener("click", function () {
        const struk = document.getElementById("struk");
        html2canvas(struk).then(canvas => {
            const imgData = canvas.toDataURL("image/png");
            const pdf = new jspdf.jsPDF();
            const width = pdf.internal.pageSize.getWidth();
            const height = (canvas.height * width) / canvas.width;
            pdf.addImage(imgData, "PNG", 0, 0, width, height);
            pdf.save("struk_tiket_<%= noTransaksi %>.pdf");
        });
    });
</script>

</body>
</html>
