<?php
// Include the AWS SDK using the Composer autoloader
require 'vendor/autoload.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

// Database connection setup
$host = 'health-dev-aurora-mysql-cluster.cluster-cxu4isccsauj.eu-west-2.rds.amazonaws.com';
$dbname = 'health';
$username = 'root';
$password = 'JAFUt#p_D.kL|hst_%jSkym]xd8A';

// Initialize status variables
$databaseConnectionStatus = "";
$s3BucketConnectionStatus = [];

// Database connection attempt
try {
  $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
  $databaseConnectionStatus = "DB connection: done<br>";

  // Create the users table with an additional column for the image URL
  $pdo->query('
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100),
      image_url VARCHAR(255)
    )
  ');

} catch (PDOException $e) {
  $databaseConnectionStatus = "DB connection: failed - " . $e->getMessage() . "<br>";
}

// S3 client setup
$s3Client = new S3Client([
  'region' => 'eu-west-2',
  'version' => 'latest'
]);

// Check if the required S3 buckets are accessible
$buckets = ['health-database-backup-dev', 'health-user-uploads-dev'];

foreach ($buckets as $bucket) {
  try {
    $s3Client->headBucket([
      'Bucket' => $bucket
    ]);
    $s3BucketConnectionStatus[] = "S3 bucket '{$bucket}' connection: done<br>";

  } catch (AwsException $e) {
    $s3BucketConnectionStatus[] = "S3 bucket '{$bucket}' connection: failed - " . $e->getAwsErrorMessage() . "<br>";
  }
}

// Handle form submission for name and image
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['image']) && isset($_POST['name'])) {
  $file = $_FILES['image'];
  $name = $_POST['name'];

  if ($file['error'] == 0) {
    $bucketName = 'health-user-uploads-dev'; // Your desired S3 bucket
    $keyName = 'uploads/' . basename($file['name']); // Path in S3 bucket

    // Attempt to upload the image to S3
    try {
      $s3Client->putObject([
        'Bucket' => $bucketName,
        'Key' => $keyName,
        'SourceFile' => $file['tmp_name'],
      ]);

      // Store the S3 URL and the name in the database
      $s3Url = "https://{$bucketName}.s3.eu-west-2.amazonaws.com/{$keyName}";
      $stmt = $pdo->prepare("INSERT INTO users (name, image_url) VALUES (:name, :image_url)");
      $stmt->execute(['name' => $name, 'image_url' => $s3Url]);

      echo "<p>Image uploaded and user information saved successfully.</p>";

    } catch (AwsException $e) {
      echo "<p>S3 Image upload failed: " . $e->getAwsErrorMessage() . "</p>";
    }
  } else {
    echo "<p>Image file upload error. Please try again.</p>";
  }
}

// Query the database for all users
$stmt = $pdo->query('SELECT * FROM users');
$users = $stmt->fetchAll();
?>

<!-- HTML layout -->
<div class="bgimg">
  <div class="topleft">
    <p>Logo is here!</p>
  </div>
  <div class="middle">
    <h1>Welcome to the Health Admin</h1>
    <hr />
    <p><?php echo $databaseConnectionStatus; ?></p>
    <p><?php echo implode("", $s3BucketConnectionStatus); ?></p>
    <hr />

    <!-- User List -->
    <h2>Users</h2>
    <ul>
      <?php foreach ($users as $user): ?>
        <li>
          <?php echo $user['name']; ?>
          <?php if (!empty($user['image_url'])): ?>
            <img src="<?php echo $user['image_url']; ?>" alt="User Image" width="100">
          <?php endif; ?>
        </li>
      <?php endforeach; ?>
    </ul>

    <!-- Combined Name and Image Upload Form -->
    <h2>Submit Name and Upload Image</h2>
    <form action="" method="post" enctype="multipart/form-data">
      <input type="text" name="name" placeholder="Name" required>
      <input type="file" name="image" required>
      <input type="submit" value="Submit">
    </form>
  </div>
  <div class="bottomleft">
    <p>tijesuniabraham.com</p>
  </div>
</div>

<style>
  /* Same style definitions as before */
  body, html { height: 100%; }
  .bgimg {
    background-image: url("https://www.w3schools.com/w3images/forestbridge.jpg");
    height: 100%; background-position: center; background-size: cover;
    position: relative; color: white; font-family: "Courier New", Courier, monospace; font-size: 25px;
  }
  .topleft { position: absolute; top: 0; left: 16px; }
  .bottomleft { position: absolute; bottom: 0; left: 16px; }
  .middle { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center; }
  hr { margin: auto; width: 40%; }
</style>
