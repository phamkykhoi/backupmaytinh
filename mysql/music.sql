-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 23, 2015 at 07:06 AM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `music`
--

-- --------------------------------------------------------

--
-- Table structure for table `albums`
--

CREATE TABLE IF NOT EXISTS `albums` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `album_name` varchar(200) NOT NULL,
  `singer_id` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=25 ;

--
-- Dumping data for table `albums`
--

INSERT INTO `albums` (`id`, `album_name`, `singer_id`) VALUES
(1, 'Nỗi nhớ vơi đầy', 6),
(2, 'Sẽ mãi bên nhau', 6),
(3, 'Em không cần anh', 6),
(4, 'Mối tình xa xưa', 6),
(5, 'Hạnh Phúc Bất Tận', 6),
(6, 'Tìm Lại Giấc Mơ', 6),
(7, 'Khúc ca cho em', 2),
(8, 'Về bên anh', 2),
(9, 'Tình yêu giáng sinh', 2),
(10, 'Cây đàn sinh viên', 2),
(11, 'Đi về nơi xa', 2),
(12, 'Đi về nơi gần', 2),
(13, 'Nhìn vào nỗi nhớ', 1),
(14, 'Tình đơn côi', 1),
(15, 'Kiếp ve sầu', 1),
(16, 'Túp lều lý tưởng', 1),
(17, 'Mãi mãi một tình yêu', 1),
(18, 'Cuộc tình trong mơ', 1),
(19, 'Khúc ca cho em', 5),
(20, 'Tìm lại bầu trời', 5),
(21, 'Như giấc chiêm bao', 5),
(22, 'Vẫn nhớ ', 5),
(23, 'Tình là gì', 5),
(24, 'Tình Yêu Lung Linh', 5);

-- --------------------------------------------------------

--
-- Table structure for table `singers`
--

CREATE TABLE IF NOT EXISTS `singers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `avata` text NOT NULL,
  `info` text NOT NULL,
  `address` text NOT NULL,
  `born` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `singers`
--

INSERT INTO `singers` (`id`, `name`, `avata`, `info`, `address`, `born`) VALUES
(1, 'Đan trường', 'dantruong.jpg', 'Tên của Đan Trường là Phạm Đan Trường, sinh 29-11-1976, là con trưởng trong gia đình của 4 anh em. Đan trường có 3 em gái và gia đình không có ai hoạt động trong nghành nghề nghệ thuật.\r\n<br/>\r\nHồi nhỏ, Đan Trường rất mê nhạc, thích hát và hát khá haỵ Năm 1996, Nhà văn hoá quận 10 tổ chức cuộc thi giọng hát hay, Đan Trường dự thi với ca khúc Gửi người tôi yêu và đoạt giải ba. Nhưng phải đến năm 1997, Đan Trường mới thực sự theo nghề ca hát.\r\n<br/>\r\nMỗi ca sĩ đều có phong cách thể hiện khác nhau, không ai giống ai Đan Trường đang nỗ lực hết sức để có một phong cách thể hiện bài hát mang dấu ấn riêng của mình.\r\n<br/>\r\nĐan Trường rất cẩn trọng trong việc chọn bài hát cho phù hợp với chất giọng của mình. May mắn Đan Trường được ngay chính các nhạc sĩ sáng tác bài hát hướng dẫn. Đan Trường đang cố gắng học thêm thanh nhạc ở cô Mỹ An (Nhạc viện thành phố), cũng như ngoại ngữ để củng cố thêm nghề nghiệp cho mình.\r\n<br/>\r\nVới những nỗ lực đó, Đan Trường đã có được một lực lượng khán giả hùng hậu, có thể nói là hùng hậu nhất Việt Nam yêu mến, và cho tới bây giờ anh đã thực hiện được 5 liveshow hoành tráng phát sóng khắp cả nước, phát hành gần 20 CD riêng và nhiều CD tổng hợp khác. Đặc biệt cùng với Cẩm Ly đã tạo nên 1 bộ đôi hoàn hảo nhất trong làn Vpop Việt Nam cho tới bây giờ. ', 'Miền Trung', '1976-11-29'),
(2, 'Mỹ Tâm', 'mytam.jpg', 'Phan Thị Mỹ Tâm (sinh ngày 16 tháng 1 năm 1981) là một nữ ca sĩ, nhạc sĩ, diễn viên, thương nhân, đạo diễn âm nhạc và nhà thiết kế thời trang người Việt Nam. Cô được biết đến bởi các hoạt động âm nhạc nghiêm túc, sáng tạo và những cống hiến không ngừng cho dòng nhạc trẻ thịnh hành từ khi chính thức khởi nghiệp vào thập niên 2000. Được mệnh danh là "Nữ hoàng V-pop", cô là một trong những cái tên gây được ảnh hưởng mạnh mẽ tại ngành công nghiệp âm nhạc Việt và là nguồn cảm hứng cho nhiều lớp nghệ sĩ trẻ tiếp sau.\r\n<br/>\r\nĐược sinh ra tại Đà Nẵng, Mỹ Tâm sớm bộc lộ năng khiếu về âm nhạc và liên tiếp giành chiến thắng tại nhiều cuộc thi ca hát lớn nhỏ lúc còn ở độ tuổi thiếu niên. Vào năm 2001, cô khởi nghiệp ca hát bằng album đầu tay mang về thành công lớn không lâu sau khi đạt tốt nghiệp thủ khoa tại trường Nhạc viện Thành phố Hồ Chí Minh. Trong xuyên suốt thập niên 2000, cô cho phát hành một chuỗi các sản phẩm âm nhạc thành công về mặt thương mại, có bao gồm các album được đề cử cho giải Cống hiến như Hoàng hôn thức giấc (2005), Vút bay (2006) và Trở lại (2008). Bên cạnh việc tự thân sáng tác, cô còn nhiều lần tham gia hợp tác với các tác giả nổi danh trong các bài hát tạo được tiếng vang cho cô như "Tóc nâu môi trầm", "Họa mi tóc nâu", "Ước gì", "Hát với dòng sông" hay "Cây đàn sinh viên".', 'Đà Nẵng', '1981-01-29'),
(3, 'Đàm Vĩnh Hưng', 'damvinhhung.jpg', 'Đàm Vĩnh Hưng tên thiệt là: Huỳnh Minh Hưng. Anh sinh ngày 2 tháng 10 năm 1971 và anh là anh cả trong gia đình của 2 anh em.\r\nAnh đã tham gia sinh hoạt văn nghệ từ CLB ca sĩ trẻ, Trung tâm văn hoá quận 10 năm 1991. Thời đó trong CLB có rất nhiều ca sĩ nổi tiếng như Tường Vy, Minh Thuận, Ðức Lâm, Nhật Hào, Tô Thanh Phương... Sau khi đoạt giải nhất cuộc thi tuyển chọn giọng ca trẻ do Công ty Văn hoá quận 10 tổ chức tại công viên hồ Kỳ Hoà năm 1992, Vĩnh Hưng chính thức đi vào con đường ca hát chuyên nghiệp.Hiện nay, CD của anh đang tạo nên một cơn sốt trên thị trường băng nhạc và không bao lâu một VCD nhạc được sản xuất bằng hệ thống kỹ thuật số sẽ được Vĩnh Hưng thực hiện như một món quà đánh dấu quá trình đi hát của mình.', 'TP. HCM', '1971-10-12'),
(4, 'Lệ Rơi', 'leroi.jpg', 'Vào Sài Gòn lập nghiệp một thời gian ngắn, Lệ Rơi đã khiến mọi người "choáng" khi liên tục được xuất hiện trên thảm đỏ của những sự kiện lớn nhất nhì showbiz Việt.\r\n<br/>\r\nNhưng nhiều người cho rằng, với bản tính hiền lành, Lệ Rơi sẽ rất khó khăn để có thể tồn tại lâu dài trong thế giới showbiz khắc nghiệt.', 'Hải Dương', '1987-10-17'),
(5, 'Tuấn Hưng', 'tuanhung', 'Sinh ra và lớn lên tại Hà Nội, nay lập nghiệp ở Sài Gòn, với Tuấn Hưng, Hà Nội mãi mãi vẫn đẹp, nên thơ và cổ kính.\r\n\r\nNăm Hưng học lớp 11 (1995), nhà trường tổ chức liên hoan văn nghệ mừng ngày Nhà giáo Việt Nam, Hưng đã tham gia chương trình với bài "Hãy hàn gắn thế giới". Giọng Tuấn Hưng được giới âm nhạc\r\nphát hiện từ dịp đó. Và cũng từ đó, trong Hưng âm ỉ một khát khao được gắn bó với âm nhạc. Đang học năm III Đại học dân lập Thăng Long (khoa\r\nQuản trị kinh doanh), Hưng quyết định chọn con đường ca hát cùng nhóm ', 'Hà Nôi', '1978-05-10'),
(6, 'Hồ Ngọc Hà', 'hongocha.jpg', 'Hồ Ngọc Hà hay còn gọi Hà Hồ sinh ra ở An Cựu, thành phố Huế, nhưng đến năm lên 8 tuổi Hồ Ngọc Hà theo bố mẹ vào lập nghiệp ở Quảng Bình. Cô là người Việt lai Pháp, bố cô là người mang hai dòng máu Pháp - Việt. Cũng chính vì thế mà Hồ Ngọc Hà còn có biệt danh Hồ An Tây, với An là tên bố còn Tây là để chỉ dòng máu Pháp - Việt của ông. Cả gia đình đều làm việc trong ngành ngân hàng. Năm 12 tuổi, cô đã phải sống xa gia đình trong ký túc xá trường Cao đẳng Văn hoá Nghệ thuật Quân đội, theo học chuyên ngành piano. ', 'Huế', '1985-10-10');

-- --------------------------------------------------------

--
-- Table structure for table `songs`
--

CREATE TABLE IF NOT EXISTS `songs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `song_name` varchar(200) NOT NULL,
  `url` text NOT NULL,
  `album_id` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
