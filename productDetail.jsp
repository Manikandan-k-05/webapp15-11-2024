<!-- Neutral Alert without colors -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="dao.*,bean.*, java.util.*, java.sql.*"%>

<%
int productId = Integer.parseInt(request.getParameter("productId"));
ProductDAO productDAO = new ProductDAO();
ProductBean product = null;

try {
	product = productDAO.getProductById(productId); // Get product by ID
} catch (SQLException e) {
	out.println("<div class='alert' style='border: 1px solid #ccc; padding: 10px;'>Error fetching product: " + e.getMessage() + "</div>");
}

if (product == null) {
	out.println("<div class='alert' style='border: 1px solid #ccc; padding: 10px;'>Product not found.</div>");
	return;
}

// Calculate 2% discount based on the product price
double productPrice = product.getPrice();
double discount = productPrice * 0.02; // 2% discount
double discountedPrice = productPrice - discount; // Final price after discount
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Details</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	background-color: #f8f9fa;
}

.product-detail {
	margin-top: 50px;
}

.product-detail img {
	height: 350px;
	object-fit: cover;
	border-radius: 10px;
}

.product-info {
	padding-left: 30px;
}

.product-info h3 {
	color: #ff5722;
}

.product-info p {
	font-size: 16px;
}

.product-info .btn {
	width: 100%;
	margin-top: 20px;
}

.product-description {
	font-size: 14px;
	color: #6c757d;
	margin-top: 20px;
}

.product-price {
	font-size: 24px;
	color: #28a745;
	font-weight: bold;
}

.feature-badge {
	margin-right: 10px;
	margin-top: 10px;
}

.feature-list {
	margin-top: 20px;
}

.offer-section {
	margin-top: 40px;
	padding: 20px;
	background-color: #fff;
	border: 1px solid #ddd;
	border-radius: 8px;
}

.offer-section h4 {
	color: #007bff;
}

.offer-item {
	margin-bottom: 10px;
	background-color: #f1f1f1;
	padding: 10px;
	border-radius: 5px;
}

.offer-item .badge {
	background-color: #ff9800;
}

.feature-list {
	margin-top: 20px;
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
}

.feature-badge {
	padding: 10px 15px;
	border-radius: 20px;
	background: linear-gradient(to right, #333, #555);
	color: white;
	font-weight: bold;
	font-size: 14px;
	box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.3);
	transition: transform 0.2s, box-shadow 0.2s, background 0.3s;
}

.feature-badge:hover {
	transform: translateY(-3px);
	box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.4);
	background: linear-gradient(to right, #444, #666);
}

.offer-section {
	margin-top: 30px;
}

.offer-item {
	transition: transform 0.3s, box-shadow 0.3s;
}

.offer-item:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.offer-item .badge.bg-success {
	background-color: #28a745;
}

.offer-item .badge.bg-info {
	background-color: #17a2b8;
}

.offer-item .badge.bg-primary {
	background-color: #007bff;
}

/* Matching Add to Cart button color */
.modal-header, .modal-footer {
	color: white;
}

.modal-header .modal-title {
	font-weight: bold;
	color: #dc3545;
}


.quantity-buttons button {
    font-size: 18px;
    padding: 5px 10px;
    margin: 0 5px;
    background-color: #dc3545; /* Matching Add to Cart button color */
    color: white;
    border: none;
    border-radius: 5px;
}

.quantity-buttons button:hover {
    background-color: #c82333; /* Darker shade on hover */
}

.quantity-buttons input {
    width: 50px;
    text-align: center;
    font-size: 18px;
    border: 1px solid #dc3545; /* Border color matching the button */
    border-radius: 5px;
    padding: 5px;
}

.modal-body {
	text-align: center;
}
</style>
</head>
<body>
	<div class="container product-detail">
		<div class="row">
			<!-- Product image -->
			<div class="col-md-6">
				<img src="uploads/<%=product.getProductImage()%>" alt="<%=product.getProductName()%>" class="img-fluid">
			</div>

			<!-- Product details -->
			<div class="col-md-6 product-info">
				<h3><%=product.getProductName()%></h3>
				<p><strong>Category:</strong> <%=product.getCategory()%></p>
				<p><strong>Stock Status:</strong> <%=product.getStock()%></p>

				<p class="product-price">&#8377;<%=product.getPrice()%></p>
				<p><strong>Discounted Price:</strong> &#8377;<%=String.format("%.2f", discountedPrice)%></p>
				<p style="text-align: justify;" class="product-description"><strong>Description:</strong> <%=product.getDescription()%></p>

				<!-- Add to Cart button -->
				<a href="javascript:void(0);" id="add-to-cart-btn" class="btn btn-danger">Add to Cart</a>

				<!-- Product Features Section -->
				<div class="feature-list">
					<span class="feature-badge">Free Delivery</span>
					<span class="feature-badge">Pay on Delivery</span>
					<span class="feature-badge">7 days Replacement</span>
					<span class="feature-badge">Warranty Policy</span>
				</div>

			</div>
		</div>

		<!-- Modal for Quantity Selection -->
		<div class="modal" tabindex="-1" id="quantityModal">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">Select Quantity</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="quantity-buttons">
							<button id="decrease">-</button>
							<input type="text" id="quantity" value="1" readonly>
							<button id="increase">+</button>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
					</div>
				</div>
			</div>
		</div>

	</div>

	<!-- Optional JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	<script>
	document.getElementById('add-to-cart-btn').addEventListener('click', function() {
	    var myModal = new bootstrap.Modal(document.getElementById('quantityModal'));
	    myModal.show();
	});

	// Increment and Decrement functionality
	document.getElementById('decrease').addEventListener('click', function() {
	    let quantity = parseInt(document.getElementById('quantity').value);
	    if (quantity > 1) {
	        document.getElementById('quantity').value = quantity - 1;
	    }
	});

	document.getElementById('increase').addEventListener('click', function() {
	    let quantity = parseInt(document.getElementById('quantity').value);
	    document.getElementById('quantity').value = quantity + 1;
	});

	// On OK button click, store product details and redirect to cart
	document.querySelector('.modal-footer .btn-secondary').addEventListener('click', function() {
	    var productId = <%= product.getProductId() %>; // Product ID from the backend
	    var quantity = document.getElementById('quantity').value;
	    var productName = "<%= product.getProductName() %>";
	    var price = <%= product.getPrice() %>;
	    var discountedPrice = <%= String.format("%.2f", discountedPrice) %>;

	    // Store product info in session (using AJAX to communicate with the server)
	    var xhr = new XMLHttpRequest();
	    xhr.open("POST", "CartServlet", true);
	    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	    xhr.onreadystatechange = function() {
	        if (xhr.readyState === 4 && xhr.status === 200) {
	            // Redirect to cart page after adding the product to session
	            window.location.href = "cart.jsp";
	        }
	    };
	    xhr.send("productId=" + productId + "&productName=" + productName + "&quantity=" + quantity + "&price=" + price + "&discountedPrice=" + discountedPrice);
	});

	</script>
</body>
</html>
