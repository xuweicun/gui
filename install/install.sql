-- phpMyAdmin SQL Dump
-- version 3.4.10.1
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2015 年 11 月 13 日 02:57
-- 服务器版本: 5.5.20
-- PHP 版本: 5.3.10

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `babycare`
--

-- --------------------------------------------------------

--
-- 表的结构 `bc_best_for_baby`
--

CREATE TABLE IF NOT EXISTS `bc_best_for_baby` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `img` varchar(150) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `thumb_img` varchar(150) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'thumb address',
  `version` varchar(50) DEFAULT NULL COMMENT '型号',
  `brand` varchar(20) DEFAULT NULL,
  `corp` varchar(50) DEFAULT NULL COMMENT '厂商',
  `company_id` int(10) DEFAULT NULL,
  `brand_id` int(10) DEFAULT '0',
  `function` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `barcode` int(20) DEFAULT NULL,
  `instruction` varchar(1500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `start_age` int(10) DEFAULT NULL COMMENT '使用年龄之起点',
  `end_age` int(10) DEFAULT NULL COMMENT '适用年龄之终点',
  `life` varchar(100) DEFAULT NULL COMMENT '最长使用寿命/保质期',
  `name` char(30) DEFAULT NULL COMMENT '名称',
  `category_id` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `function` (`function`),
  KEY `barcode` (`barcode`),
  KEY `life` (`life`),
  KEY `brand_id` (`brand_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='宝宝用品精选' AUTO_INCREMENT=2393 ;

--
-- 转存表中的数据 `bc_best_for_baby`
--

INSERT INTO `bc_best_for_baby` (`id`, `img`, `thumb_img`, `version`, `brand`, `corp`, `company_id`, `brand_id`, `function`, `barcode`, `instruction`, `start_age`, `end_age`, `life`, `name`, `category_id`) VALUES
(1, '/ThinkPHP/Public/Uploads/20150315/55058a48a79c1.jpg', '/ThinkPHP/Public/Uploads/20150315/55058a48a79c1_thumb.jpg', '儿童款', '乳胶颗粒枕', '', 1, 20, '枕头', 0, '', 6, 120, '0', '乳胶颗粒枕', 40),
(2339, '/ThinkPHP/Public/Uploads/20150314/5503fc37b5a55.jpg', '/ThinkPHP/Public/Uploads/20150314/5503fc37b5a55_thumb.jpg', '', 'maxi-cosi', 'Bee', 1, 21, '安全座椅', 3939, '&lt;p&gt;&amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;Pria 70 适合8-63斤的孩子，Pria 85是2014年秋新出型号， 适合13-77斤的孩子，可以根据孩子体重来选择。 &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;&lt;/p&gt;', 0, 0, '', NULL, NULL),
(2340, '/ThinkPHP/Public/Uploads/20150318/55096c5125796.jpg', '/ThinkPHP/Public/Uploads/20150318/55096c5125796_thumb.jpg', ' 有机棉长型围裙婴儿用', 'Cuddledry', 'Bee', 1, NULL, NULL, 0, '', 2, 24, '0', NULL, NULL),
(2341, '/ThinkPHP/Public/Uploads/20150318/550972a9dbd03.jpg', '/ThinkPHP/Public/Uploads/20150318/550972a9dbd03_thumb.jpg', '儿童', 'Cuddledry ', 'Cuddledry ', NULL, NULL, NULL, 0, '', 2, 48, NULL, NULL, NULL),
(2342, '/ThinkPHP/Public/Uploads/20150320/550bacb882898.png', '/ThinkPHP/Public/Uploads/20150320/550bacb882898_thumb.png', '', '', '', 1, 20, NULL, 0, '', 0, 0, '过期时间见瓶底EXP字样', '', 40),
(2343, '/ThinkPHP/Public/Uploads/20150322/550e0eb0e41df.jpg', '/ThinkPHP/Public/Uploads/20150322/550e0eb0e41df_thumb.jpg', '90滴', 'Ddrops', 'Baby', NULL, NULL, NULL, 2147483647, '', 0, 0, NULL, NULL, NULL),
(2347, '/ThinkPHP/Public/Uploads/20150322/550e99647e129.jpg', '/ThinkPHP/Public/Uploads/20150322/550e99647e129_thumb.jpg', '50g', 'BabyRub', 'Vicks', NULL, NULL, NULL, 0, '', 3, 0, NULL, NULL, NULL),
(2348, '/ThinkPHP/Public/Uploads/20150324/5511573d8db77.jpg', '/ThinkPHP/Public/Uploads/20150324/5511573d8db77_thumb.jpg', '500ml', 'Floradix Iron', 'Salus', NULL, NULL, NULL, 0, '&lt;p&gt;每个女人都值得拥有的补血圣品：针对缺铁性贫血，补铁、补气、补血，血指升高，面色红润，调经，经期稳定， 痛经消失，手脚不再冰凉，淡斑，美容，去黄气，备孕首选，孕妇必备。&lt;/p&gt;', 0, 0, NULL, NULL, NULL),
(2349, '/ThinkPHP/Public/Uploads/20150324/551159661ea2f.jpg', '/ThinkPHP/Public/Uploads/20150324/551159661ea2f_thumb.jpg', '婴儿', '', 'aden+anais', NULL, 20, NULL, 0, '&lt;p&gt;这款包巾的尺寸大约为120cm*120cm ，材质是穆斯林棉，用途非常广，可以做婴儿车罩，披肩，哺乳围巾，尿布垫等.&lt;/p&gt;', 0, 24, NULL, NULL, NULL),
(2360, '', '', '', 'Muslin', 'aden', 4, NULL, NULL, 0, '', 0, 24, '36', NULL, NULL),
(2361, '', '', '', '', 'Muschin', 5, 20, NULL, 0, '&lt;p&gt;玩具整理篮&lt;br/&gt;&lt;/p&gt;', 0, 12, '24', NULL, NULL),
(2362, '', '', '5s', 'iPhone', 'Apple', 6, NULL, NULL, 23, '', 24, 48, '12', NULL, NULL),
(2363, '', '', '恐龙', 'Cuddledry', 'Bee', 1, 22, NULL, 0, '', 5, 48, '无', NULL, NULL),
(2364, '', '', '', '', 'Muschin', 5, 20, NULL, 0, '', 2, 4, '', NULL, NULL),
(2365, '/ThinkPHP/Public/Uploads/20150426/553c9dca5bdc1.jpg', '/ThinkPHP/Public/Uploads/20150426/553c9dca5bdc1_thumb.jpg', '', 'Sugar Wash', 'Betta', 8, NULL, NULL, 2147483647, '', 0, 0, '无明确标识', NULL, NULL),
(2366, '', '', '', '智能', 'Betta', 8, NULL, NULL, 0, '', 0, 36, '', NULL, NULL),
(2367, '', '', '', 'Aquaphor', 'Eucerin', 9, NULL, NULL, 0, '', 0, 36, '见瓶尾封口处', NULL, NULL),
(2368, '', '', '', '', 'Wubbanub', 10, 20, NULL, 0, '', 0, 24, '', NULL, NULL),
(2369, '', '', '南瓜', '', 'Hipp', 11, 20, NULL, 0, '', 9, 24, '', NULL, NULL),
(2370, '', '', '', '', 'Hipp', 11, 20, NULL, 0, '&lt;p&gt;&lt;span style=\\&quot;font-size: 18px;color:;font-family:Arial\\&quot;&gt;&lt;/span&gt;&lt;span style=\\&quot;font-size: 18px;color:;font-family:Arial\\&quot;&gt;&lt;/span&gt;喜宝的肉泥产品全部来自天然有机脱敏的肉产品。可以与喜宝蔬菜泥混合，组成理想的营养配餐。&lt;br/&gt;-不添加盐&lt;br/&gt;-富含Omega-3脂肪酸的菜籽油&lt;br/&gt;-脱敏&lt;br/&gt;-天然有机&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', 12, 36, '见瓶身', NULL, NULL),
(2371, '', '', '', '脱敏鸡肉泥', 'Hipp', 11, NULL, NULL, 0, '&lt;p&gt;喜宝的肉泥产品全部来自天然有机脱敏的肉产品。可以与喜宝蔬菜泥混合，组成理想的营养配餐。&lt;br/&gt;-不添加盐&lt;br/&gt;-富含Omega-3脂肪酸的菜籽油&lt;br/&gt;-脱敏&lt;br/&gt;-天然有机&lt;/p&gt;', 12, 36, '', NULL, NULL),
(2372, '', '', '', '', 'Burts Bee', 2, 20, NULL, 0, NULL, 0, 0, '', NULL, NULL),
(2373, '', '', '', '曼哈顿球', 'Manhattan Toy', 12, NULL, NULL, 0, '&lt;p&gt;这款Winkel儿童磨牙牙胶，丰富艳丽的颜色，能够吸引宝宝的注意力，并训练宝宝对色彩的敏感性，促进视力发育。独特的空心细管外型，方便宝宝磨牙，细细的线条宝宝的小手也能拿握.&lt;/p&gt;', 0, 0, '', NULL, NULL),
(2374, '', '', '2014', 'Abolo', 'Hipp', 11, 39, NULL, 0, NULL, 12, 24, '3', NULL, NULL),
(2375, '', '', '4s', 'iPhone', 'Apple', 6, 33, NULL, 0, NULL, 0, 0, '', NULL, NULL),
(2376, '', '', '', '', '', 1, 20, NULL, 0, '', 0, 0, '', NULL, NULL),
(2377, '', '', '海洋动物系列', 'Happy', 'Sassy', 14, 43, NULL, 0, NULL, 0, 0, '', NULL, NULL),
(2378, '', '', '', 'Happy', 'Sassy', 14, 43, NULL, 0, '&lt;p&gt;海洋动物系列&lt;br/&gt;&lt;/p&gt;', 3, 24, '', NULL, NULL),
(2379, '', '', '默认版本', '', '', 1, 20, NULL, 0, NULL, 4, 12, '20', NULL, NULL),
(2380, '', '', '4s', '', '', 1, 20, NULL, 0, NULL, 0, 0, '', NULL, NULL),
(2381, '', '', '75', NULL, NULL, NULL, 0, NULL, 0, NULL, 6, 12, '2', 'what', NULL),
(2382, '', '', 'dd', NULL, NULL, NULL, 31, NULL, 0, NULL, 0, 0, 'd', 'hh', NULL),
(2383, '', '', '默认版本', NULL, NULL, NULL, 48, NULL, 0, NULL, 6, 36, '', '硅胶软围嘴', NULL),
(2384, '/ThinkPHP/Public/Uploads/20150729/55b895dd75f26.jpg', '/ThinkPHP/Public/Uploads/20150729/55b895dd75f26_thumb.jpg', '', '乳胶颗粒枕', '', 1, 51, NULL, 0, NULL, 0, 0, '', '沙发哈哈', NULL),
(2385, '/ThinkPHP/Public/Uploads/20150729/55b896497b5e6.jpg', '/ThinkPHP/Public/Uploads/20150729/55b896497b5e6_thumb.jpg', '22', NULL, NULL, NULL, 51, NULL, 0, NULL, 0, 0, '', '新沙发', NULL),
(2386, NULL, '', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, '', '', 0),
(2387, NULL, '', 'hallo', NULL, NULL, NULL, 0, NULL, 0, NULL, 6, 12, '', 'maxi-cosi安全座椅', 0),
(2388, NULL, '', '地方', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, '', '沙发哈哈', 0),
(2389, NULL, '', '而非', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, '', '沙发哈哈', 16),
(2390, NULL, '', '', NULL, NULL, NULL, 0, NULL, 0, NULL, 0, 0, '', '沙发哈哈', 0),
(2391, '/ThinkPHP/Public/Uploads/20150825/55dbe14ea61c2.jpg', '/ThinkPHP/Public/Uploads/20150825/55dbe14ea61c2_thumb.jpg', 'pria 70', 'maxi-cosi', '', 1, 21, NULL, 0, NULL, 2, 3, '', 'maxi-cosi安全座椅 2 pria 70', 16),
(2392, '', '', 'heil', NULL, NULL, NULL, 20, NULL, 0, NULL, 3, 0, '', '乳胶颗粒枕, 乳胶颗粒枕', 0);

-- --------------------------------------------------------

--
-- 表的结构 `bc_brand`
--

CREATE TABLE IF NOT EXISTS `bc_brand` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `corp_id` int(10) NOT NULL,
  `name` char(15) NOT NULL,
  `cn_name` char(15) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `category_id` int(5) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`,`cn_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='品牌表' AUTO_INCREMENT=56 ;

--
-- 转存表中的数据 `bc_brand`
--

INSERT INTO `bc_brand` (`id`, `corp_id`, `name`, `cn_name`, `description`, `category_id`) VALUES
(20, 13, '乳胶颗粒枕', '乳胶颗粒枕', '&lt;p&gt;特别好&lt;br/&gt;&lt;/p&gt;', 0),
(21, 1, 'maxi-cosi', 'maxi-cosi', NULL, 0),
(22, 1, 'Cuddledry', 'Cuddledry', NULL, 0),
(23, 0, 'Cuddledry', 'Cuddledry', NULL, 0),
(24, 7, 'Feroglobin b12', 'Feroglobin b12', NULL, 0),
(25, 0, 'Ddrops', 'Ddrops', NULL, 0),
(26, 0, 'BabyRub', 'BabyRub', NULL, 0),
(27, 0, 'Floradix Iron', 'Floradix Iron', NULL, 0),
(28, 0, '福克斯', '福克斯', NULL, 0),
(29, 2, '薄荷防蚊水', '薄荷防蚊水', NULL, 0),
(30, 2, 'ss', 'ss', NULL, 0),
(31, 2, 'test', 'test', NULL, 0),
(32, 4, 'Muslin', 'Muslin', NULL, 0),
(33, 6, 'iPhone', 'iPhone', NULL, 0),
(34, 8, 'Sugar Wash', 'Sugar Wash', NULL, 0),
(35, 8, '智能', '智能', NULL, 0),
(36, 9, 'Aquaphor', 'Aquaphor', NULL, 0),
(37, 11, '脱敏鸡肉泥', '脱敏鸡肉泥', NULL, 0),
(38, 12, '曼哈顿球', '曼哈顿球', NULL, 0),
(39, 0, 'Abolo', '', NULL, 0),
(40, 4, 'test', '', NULL, 0),
(41, 12, 'Blur', '波拉', NULL, 0),
(42, 8, 'kaka', '卡卡', '&lt;p&gt;奶粉盒&lt;br/&gt;&lt;/p&gt;', 0),
(43, 14, 'Happy', '嗨皮', NULL, 0),
(44, 2, 'Laji', '垃圾', NULL, 0),
(46, 15, 'pria 70', '普利亚', NULL, 0),
(47, 15, 'pria', '普利亚', '', 0),
(48, 16, 'Soft Bib', '', NULL, 0),
(49, 17, 'Sitzsack Sommer', '懒人沙发', '&lt;h2&gt;&lt;span style=\\&quot;font-size: 16px;\\&quot;&gt;Bezug aus Velours und Baumwolle/Polyester, abnehmbar und bei 30°C waschbar.&amp;nbsp;&lt;/span&gt;&lt;br/&gt;&lt;/h2&gt;&lt;p&gt;Innensack mit Styropor-Kügelchen gefüllt.&amp;nbsp;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', 0),
(50, 17, 'New safa', '新沙发', NULL, 0),
(51, 1, 'New safad', '订单', '', 38),
(52, 1, 'testss', '托尔斯泰', NULL, 0),
(53, 18, 'PPP', '得得得', NULL, 0),
(54, 0, '', '', NULL, 0),
(55, 19, 'B. BOX', '', '&lt;p&gt;水杯&lt;br/&gt;&lt;/p&gt;', 0);

-- --------------------------------------------------------

--
-- 表的结构 `bc_brand_category`
--

CREATE TABLE IF NOT EXISTS `bc_brand_category` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `brand_id` int(10) NOT NULL,
  `category_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `brand_id` (`brand_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='品牌和物品类别的关联表' AUTO_INCREMENT=16 ;

--
-- 转存表中的数据 `bc_brand_category`
--

INSERT INTO `bc_brand_category` (`id`, `brand_id`, `category_id`) VALUES
(3, 1, 9),
(4, 1, 10),
(5, 1, 15),
(6, 52, 9),
(7, 52, 10),
(8, 52, 15),
(9, 53, 9),
(10, 53, 10),
(11, 54, 0),
(12, 55, 35),
(15, 20, 9);

-- --------------------------------------------------------

--
-- 表的结构 `bc_category`
--

CREATE TABLE IF NOT EXISTS `bc_category` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `layer` smallint(2) DEFAULT '0' COMMENT '层级：0表示底层节点',
  `father_id` int(10) DEFAULT '0' COMMENT '父节点：默认为0，表示其他分类',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='共分三层，2层为根目录，1层为子目录，0层为物品名称' AUTO_INCREMENT=42 ;

--
-- 转存表中的数据 `bc_category`
--

INSERT INTO `bc_category` (`id`, `name`, `layer`, `father_id`) VALUES
(4, 'd', 0, 10),
(5, '蚊不叮', 0, 9),
(6, '防蚊水', 0, 9),
(7, 'but', 0, 0),
(8, '浴巾', 0, 22),
(9, '儿童药膏', 1, 0),
(10, '推车', 1, 0),
(11, '出行必备', 2, 0),
(12, '健康护理', 2, 0),
(13, '玩具整理篮', 0, 23),
(14, '智能手机', 0, 15),
(15, '手机', 1, 0),
(16, '锤子', 0, 17),
(17, '工具', 0, 0),
(18, 'maxi-cosi pria 70 ', 0, 0),
(19, '安全座椅', 0, 0),
(20, '补铁补锌口服液', 0, 21),
(21, '维生素补充剂', 0, 0),
(22, '洗浴用品', 0, 0),
(23, '儿童收纳', 0, 0),
(24, '奶瓶清洗剂', 0, 0),
(25, '护臀霜', 0, 0),
(26, '玩偶奶嘴', 0, 0),
(27, '蔬菜泥', 0, 28),
(28, '辅食', 0, 0),
(29, '脱敏牛肉泥', 0, 0),
(30, '枕头', 0, 0),
(31, '娱乐', 2, 0),
(32, '玩具', 1, 31),
(33, '海洋球', 0, 32),
(34, '洗澡玩具', 0, 0),
(35, '餐具', 1, 0),
(36, '围嘴', 0, 35),
(37, '育儿家居', 1, 0),
(38, '沙发', 0, 37),
(39, '护臀霜', 0, 9),
(40, 'maomi', 0, 9),
(41, 'stroller', 1, 11);

-- --------------------------------------------------------

--
-- 表的结构 `bc_color`
--

CREATE TABLE IF NOT EXISTS `bc_color` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `title` varchar(10) NOT NULL COMMENT '颜色',
  `R` int(3) NOT NULL,
  `G` int(3) NOT NULL,
  `B` int(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `bc_color`
--

INSERT INTO `bc_color` (`id`, `title`, `R`, `G`, `B`) VALUES
(1, '红', 255, 0, 0),
(2, '蓝', 0, 0, 255),
(3, '白', 255, 255, 255),
(4, '黑', 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `bc_company`
--

CREATE TABLE IF NOT EXISTS `bc_company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `country` varchar(30) DEFAULT NULL COMMENT '产地',
  `since` smallint(5) DEFAULT NULL COMMENT '创建年份',
  `introduction` varchar(1000) DEFAULT NULL COMMENT '简介',
  `cn_name` varchar(30) DEFAULT NULL COMMENT '别名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='品牌' AUTO_INCREMENT=21 ;

--
-- 转存表中的数据 `bc_company`
--

INSERT INTO `bc_company` (`id`, `name`, `country`, `since`, `introduction`, `cn_name`) VALUES
(1, 'Bee', '荷兰', 2000, '&lt;p&gt;注明厂商&lt;br/&gt;&lt;/p&gt;', '小蜜蜂'),
(2, 'Burt\\''s Bee', '', 2000, NULL, ''),
(3, 'his\\''ss', NULL, NULL, NULL, NULL),
(4, 'aden', NULL, NULL, NULL, NULL),
(5, 'Muschin', NULL, NULL, NULL, NULL),
(6, 'Apple', NULL, NULL, NULL, NULL),
(7, 'VOBORIC', NULL, NULL, NULL, NULL),
(8, 'Betta', NULL, NULL, NULL, NULL),
(9, 'Eucerin', NULL, NULL, NULL, NULL),
(10, 'Wubbanub', NULL, NULL, NULL, NULL),
(11, 'Hipp', NULL, NULL, NULL, NULL),
(12, 'Manhattan Toy', '美国', 2000, NULL, '曼哈顿玩具'),
(13, 'COCO-MAT', NULL, NULL, NULL, NULL),
(14, 'Sassy', '美国', 2000, NULL, '沙溪'),
(15, 'maxi-cosi', 'USA', 2000, NULL, '麦克士'),
(16, 'Baby Bjorn', '瑞典', 2000, NULL, ''),
(17, 'HABA', '德国', 2000, NULL, '哈巴'),
(18, 'Britax', '德国', 2000, NULL, '不理他呢'),
(19, 'B. BOX', '澳大利亚', 2000, NULL, ''),
(20, 'ttt', '', 2000, NULL, 'dd');

-- --------------------------------------------------------

--
-- 表的结构 `bc_cost`
--

CREATE TABLE IF NOT EXISTS `bc_cost` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `item` varchar(30) NOT NULL,
  `cost` decimal(8,2) NOT NULL,
  `time` int(11) NOT NULL,
  `dest` varchar(30) DEFAULT NULL COMMENT 'pays to whom',
  `frozen` tinyint(1) DEFAULT NULL COMMENT 'if frozen, the money will be back.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成本表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `bc_img`
--

CREATE TABLE IF NOT EXISTS `bc_img` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `img` varchar(150) NOT NULL,
  `thumb_img` varchar(150) NOT NULL,
  `is_main` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

--
-- 转存表中的数据 `bc_img`
--

INSERT INTO `bc_img` (`id`, `img`, `thumb_img`, `is_main`) VALUES
(1, '/ThinkPHP/Public/Uploads/20150718/55a9a4edabdc9.jpg', '/ThinkPHP/Public/Uploads/20150718/55a9a4edabdc9_thumb.jpg', 0),
(4, '/ThinkPHP/Public/Uploads/20150911/55f29abeacf59.jpg', '/ThinkPHP/Public/Uploads/20150911/55f29abeacf59_thumb.jpg', 0),
(5, '/ThinkPHP/Public/Uploads/20150914/55f6621d1117c.jpg', '/ThinkPHP/Public/Uploads/20150914/55f6621d1117c_thumb.jpg', 0),
(6, '/ThinkPHP/Public/Uploads/20150914/55f68294ac8e4.jpg', '/ThinkPHP/Public/Uploads/20150914/55f68294ac8e4_thumb.jpg', 0),
(7, '/ThinkPHP/Public/Uploads/20150914/55f682a60ad88.jpg', '/ThinkPHP/Public/Uploads/20150914/55f682a60ad88_thumb.jpg', 0),
(10, '/ThinkPHP/Public/Uploads/20151102/5636b45aa53cd.jpg', '/ThinkPHP/Public/Uploads/20151102/5636b45aa53cd_thumb.jpg', 0),
(11, '/ThinkPHP/Public/Uploads/20151102/5636c11789d50.jpg', '/ThinkPHP/Public/Uploads/20151102/5636c11789d50_thumb.jpg', 0),
(12, '/ThinkPHP/Public/Uploads/20151102/5636c122938bb.jpg', '/ThinkPHP/Public/Uploads/20151102/5636c122938bb_thumb.jpg', 0),
(14, '/ThinkPHP/Public/Uploads/20151103/563815ae2a5a3.jpg', '/ThinkPHP/Public/Uploads/20151103/563815ae2a5a3_thumb.jpg', 0),
(15, '/ThinkPHP/Public/Uploads/20151103/563816ad6d2e5.jpg', '/ThinkPHP/Public/Uploads/20151103/563816ad6d2e5_thumb.jpg', 0),
(16, '/ThinkPHP/Public/Uploads/20151103/56381abf13e30.jpg', '', 0),
(17, '/ThinkPHP/Public/Uploads/20151103/5638245a15fd3.jpg', '/ThinkPHP/Public/Uploads/20151103/5638245a15fd3_thumb.jpg', 0),
(18, '/ThinkPHP/Public/Uploads/20151103/563827037ad52.jpg', '/ThinkPHP/Public/Uploads/20151103/563827037ad52_thumb.jpg', 0),
(19, '/ThinkPHP/Public/Uploads/20151109/563ff2c2b1148.jpg', '/ThinkPHP/Public/Uploads/20151109/563ff2c2b1148_thumb.jpg', 0),
(20, '/ThinkPHP/Public/Uploads/20151109/563ff2d8e0eb8.jpg', '/ThinkPHP/Public/Uploads/20151109/563ff2d8e0eb8_thumb.jpg', 0);

-- --------------------------------------------------------

--
-- 表的结构 `bc_instruction`
--

CREATE TABLE IF NOT EXISTS `bc_instruction` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `item_id` int(10) NOT NULL,
  `title` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `content` varchar(2000) COLLATE utf8_bin NOT NULL,
  `title_id` int(10) DEFAULT NULL COMMENT '关键词来源',
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='说明书' AUTO_INCREMENT=42 ;

--
-- 转存表中的数据 `bc_instruction`
--

INSERT INTO `bc_instruction` (`id`, `item_id`, `title`, `content`, `title_id`) VALUES
(5, 2340, '特性', '&lt;p&gt;&lt;span style=&quot;color: rgb(51, 51, 51); font-family: Arial, &amp;#39;Microsoft YaHei&amp;#39;; font-size: 14px; line-height: 25px; background-color: rgb(255, 255, 255);&quot;&gt;&amp;nbsp;让您可以腾出双手为婴儿沐浴和抱起婴儿而不会把您弄湿，令您时刻保持干爽；&lt;/span&gt;&lt;/p&gt;', NULL),
(6, 2340, '材质', '&lt;p&gt;&lt;span style=&quot;color: rgb(51, 51, 51); font-family: Arial, &amp;#39;Microsoft YaHei&amp;#39;; font-size: 14px; line-height: 25px; background-color: rgb(255, 255, 255);&quot;&gt;&amp;nbsp;未经漂白的有机绵及天然竹纤维 ；丝质柔软、高吸湿力及快干； 天然抗菌成份 - 最适合婴儿的敏感皮肤&lt;/span&gt;&lt;/p&gt;', NULL),
(7, 2342, '用量', '&lt;p&gt;成人：每日两次，每次5ml;&lt;/p&gt;&lt;p&gt;儿童：1-3岁每日2.5ml;4-6岁每日两次，每次2.5ml;7-12岁每日1-2次，每次5ml;&lt;/p&gt;', NULL),
(8, 2342, '注意事项', '&lt;p&gt;用前请摇匀。&lt;/p&gt;', NULL),
(9, 2342, '成分及含量/10ml', '&lt;p&gt;&lt;img src=&quot;/ueditor/php/upload/image/20150320/1426829256840927.jpg&quot; title=&quot;1426829256840927.jpg&quot; alt=&quot;营养成分.jpg&quot; width=&quot;645&quot; height=&quot;517&quot; style=&quot;width: 645px; height: 517px;&quot;/&gt;&lt;/p&gt;&lt;p&gt;维生素B1-B3&lt;/p&gt;&lt;p&gt;维生素B12&lt;/p&gt;&lt;p&gt;叶酸，维生素C，泛酸&lt;/p&gt;&lt;p&gt;铁14mg，锌10mg，铜0.25mg，Lysine（磷）80mg，麦芽1000mg，蜂蜜200mg&lt;/p&gt;', NULL),
(10, 2343, '成分说明（Ingredients）', '&lt;p&gt;维他命D3;&lt;/p&gt;&lt;p&gt;分馏椰子油(fractionated coconut oil);&amp;nbsp;&lt;/p&gt;&lt;p&gt;不含谷物、鸡蛋、贝壳、鱼类、花生、豆类、糖分、玉米、小麦、人工色素、防腐剂和着色剂等。&lt;/p&gt;', NULL),
(11, 2343, '使用说明', '&lt;p&gt;每日一滴;&lt;/p&gt;&lt;p&gt;哺乳时将液体滴在乳头上（使用奶瓶时混合于奶液中）;&lt;/p&gt;', NULL),
(12, 2343, '保存方式', '&lt;p&gt;4-26摄氏度环境下保存即可;夏天需要放在冰箱的保鲜层。&lt;/p&gt;', NULL),
(13, 2343, '截止日期', '&lt;p&gt;可查看包装底部是否有EXP XX(月份)-XXXX(年份)字样;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;小提示：EXP 04-2019表示将于2019见4月份过期;&lt;/p&gt;', NULL),
(14, 2347, '致敏性', '&lt;p&gt;有&lt;a href=&quot;/index.php&quot; target=&quot;_self&quot;&gt;过敏&lt;/a&gt;可能。需要做&lt;a href=&quot;/index.php&quot; target=&quot;_blank&quot;&gt;耳后测试&lt;/a&gt;通过后再使用。&lt;/p&gt;', NULL),
(15, 2347, '成分', '&lt;p&gt;芦荟;椰子油;蓝桉;迷迭香油;&lt;/p&gt;', NULL),
(16, 2347, '用法', '&lt;p&gt;注意：一定要先做耳后测试！！！&lt;/p&gt;&lt;p&gt;在耳后测试通过的前提下，取出少量药膏，在手掌心上搓热之后，均匀涂抹在宝宝的&lt;strong&gt;脚心、前胸和后背&lt;/strong&gt;上。&lt;/p&gt;&lt;p&gt;每次在一个部位涂抹后，最好进行短暂的按摩，其过程跟擦手油完全相同。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', NULL),
(17, 2347, '小编个人提示', '&lt;p&gt;在宝宝疑似着凉但还没有明显感冒症状的时候，涂抹BabyRub有一定的预防作用，跟喝姜汤原理相似哦。&lt;/p&gt;', NULL),
(18, 2347, '妈妈切记', '&lt;p&gt;不能食用！&lt;/p&gt;&lt;p&gt;仅限外用！&lt;/p&gt;&lt;p&gt;不能接触有创伤的皮肤表面！&lt;/p&gt;&lt;p&gt;不能用热水、微波炉加热!&lt;/p&gt;', NULL),
(19, 2348, '特别提示', '&lt;p&gt;本品为膳食营养补充剂；本品不能代替药物；本品不宜超过推荐量或与同类营养补充剂同时食用。&lt;/p&gt;', NULL),
(20, 2348, '使用方法', '&lt;p&gt;1-5岁宝宝：每天一次，每次5ml;&lt;/p&gt;&lt;p&gt;6-12岁儿童：每天一次，每次10ml;&lt;/p&gt;&lt;p&gt;13岁以上：每天二次，每次10ml，孕妇可酌情增加;&lt;br/&gt;&lt;/p&gt;', NULL),
(21, 2349, '材质', '&lt;p&gt;Muslin棉。&lt;/p&gt;', NULL),
(22, 2349, 'Muslin棉', '&lt;p style=&quot;white-space: normal;&quot;&gt;Muslin是一种非常独特的棉，是世界上最古老最珍贵的一种织物。7000前最早由古印第安文明用来对部落成员进行装饰。埃及人用Muslin棉包裹婴儿。古希腊人和古罗马人用Muslin棉来做服饰的装饰。17世纪被法国人用来制作复杂精致的衬裙。中世纪欧洲普通阶层的人们也将Muslin棉当作日常的服装来穿。&lt;/p&gt;&lt;p style=&quot;white-space: normal;&quot;&gt;Muslin棉的历史就是人类文明的历史。&lt;/p&gt;&lt;p style=&quot;white-space: normal;&quot;&gt;17世纪后期被首次引进英格兰。Muslin棉的材质是独一无二且非常轻盈，保暖又透气，适用于任何季节。因为Muslin棉是全世界唯一的最柔软的天然棉，它的透气性以及可延展性是不可取代的，而其独特的编织技法更使得空气能够自由流通。这种棉可以帮助宝宝体温得以自然调节，消除了普通材质容易导致的温度过高之后带给宝宝的困扰。同时又能确保宝宝的温暖与舒适。用aden+anais包巾安全舒适地包住您的宝宝，妈妈们慢慢和会发现，只要宝宝在这块包巾中，就绝对可以拥有平静而安心的睡眠。而且，这不仅仅是个包巾哦，它还可以当作童车遮盖，拍嗝垫布，护理毯，夏季的空调被等。充分发挥你的想象力来利用Aden+Anais大包巾吧。尤其，当你清洗了一次又一次后，你会惊喜地发现，它不但没有变的僵硬，反而越来越软。它的质量和设计促使它成为您宝宝的必备。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', NULL),
(23, 2365, '成分', '&lt;p&gt;甘蔗和椰子油提取的天然油脂;不含防腐剂、香精、染色剂等工业原料。&lt;br/&gt;&lt;/p&gt;', NULL),
(24, 2365, '使用方法', '&lt;p&gt;每次滴1-2滴。用完后立即密封，天然成分与空气接触后可能变色，属于正常现象。&lt;br/&gt;&lt;/p&gt;', NULL),
(25, 2365, '应用范围', '&lt;p&gt;可以清洗奶瓶、奶嘴和宝宝餐具等。&lt;br/&gt;&lt;/p&gt;', NULL),
(26, 2367, '功能主治', '&lt;p&gt;这款万用修复乳霜是美国皮肤科及儿科医生极力推荐的产品，几乎可以解决宝宝日常所有皮肤问题，包括：皮疹、晒伤、烫伤、湿疹、擦伤甚至除毛时的刮伤。&lt;/p&gt;', NULL),
(27, 2367, '主要成分', '&lt;p&gt;化妆用凡士林【矿物蜡，在肌肤表面形成一道保护膜，使皮肤的水分不易蒸发散失，而且它极不溶于水，可长久附着在皮肤上，因此具有很好的保湿效果】&lt;/p&gt;&lt;p&gt;矿物油【mineral oil，高纯度化妆级白油，可增加湿润感】&lt;/p&gt;&lt;p&gt;甘油【Glycerin，保湿滋润】&lt;/p&gt;&lt;p&gt;化妆品级羊毛脂【优良的滋润性物质】&lt;/p&gt;&lt;p&gt;泛酰醇【泛酰醇可使皮肤美丽、光滑、富有营养。】&lt;/p&gt;&lt;p&gt;无添加防腐剂和色素。&lt;/p&gt;', NULL),
(28, 2370, '使用方法', '&lt;p&gt;1.加热后直接喂食给宝宝或者在米糊餐中加入肉泥&lt;br/&gt;2.用微波炉加热或隔水热&lt;br/&gt;3.瓶内剩余部分请务必放于冰箱冷藏，开封后2-3日内食用完最为新鲜&lt;/p&gt;', NULL),
(37, 1, 'df', '&lt;p&gt;dfdf&lt;br/&gt;&lt;/p&gt;', 4),
(38, 1, '34', '&lt;p&gt;iui&lt;br/&gt;&lt;/p&gt;', 5),
(39, 1, '88', '&lt;p&gt;同意&lt;br/&gt;&lt;/p&gt;', 6),
(40, 1, '方法', '&lt;p&gt;56 &lt;br/&gt;&lt;/p&gt;', 11),
(41, 1, '安装视频', '&lt;p&gt;56&lt;br/&gt;&lt;/p&gt;', 12);

-- --------------------------------------------------------

--
-- 表的结构 `bc_instruction_title`
--

CREATE TABLE IF NOT EXISTS `bc_instruction_title` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `title` char(30) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COMMENT='说明标题表' AUTO_INCREMENT=14 ;

--
-- 转存表中的数据 `bc_instruction_title`
--

INSERT INTO `bc_instruction_title` (`id`, `title`) VALUES
(4, 'df'),
(5, '34'),
(6, '88'),
(11, '方法'),
(12, '安装视频'),
(13, '同意');

-- --------------------------------------------------------

--
-- 表的结构 `bc_item_img`
--

CREATE TABLE IF NOT EXISTS `bc_item_img` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `view_id` int(5) NOT NULL,
  `item_id` int(10) NOT NULL,
  `size_id` int(10) NOT NULL,
  `img_id` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=28 ;

--
-- 转存表中的数据 `bc_item_img`
--

INSERT INTO `bc_item_img` (`id`, `view_id`, `item_id`, `size_id`, `img_id`) VALUES
(6, 9, 1, 9, 6),
(7, 19, 2383, 13, 1),
(10, 9, 1, 0, 4),
(11, 0, 1, 0, 5),
(12, 9, 1, 0, 6),
(13, 9, 1, 0, 7),
(16, 0, 1, 0, 10),
(17, 0, 1, 0, 11),
(18, 0, 1, 0, 12),
(20, 0, 1, 0, 14),
(21, 0, 1, 0, 15),
(22, 0, 1, 0, 16),
(23, 0, 1, 0, 17),
(24, 0, 1, 0, 18),
(25, 8, 1, 0, 19),
(26, 8, 1, 0, 19),
(27, 8, 1, 0, 20);

-- --------------------------------------------------------

--
-- 表的结构 `bc_item_pattern`
--

CREATE TABLE IF NOT EXISTS `bc_item_pattern` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `item_id` int(10) NOT NULL,
  `cn_name` varchar(20) NOT NULL COMMENT '中文名',
  `origin_name` varchar(20) DEFAULT NULL COMMENT '原名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='款式表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `bc_item_size`
--

CREATE TABLE IF NOT EXISTS `bc_item_size` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `size` char(20) NOT NULL,
  `order` int(2) NOT NULL,
  `unit` varchar(5) NOT NULL,
  `item_id` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='物品规格表' AUTO_INCREMENT=19 ;

--
-- 转存表中的数据 `bc_item_size`
--

INSERT INTO `bc_item_size` (`id`, `size`, `order`, `unit`, `item_id`) VALUES
(1, '', 0, 'd', 0),
(9, '250ml', 0, '', 1),
(10, '', 0, '', 2379),
(12, '', 0, '', 2380),
(13, '', 0, '', 2383),
(14, '默认规格2', 0, '', 2383),
(15, '修改', 0, '', 1),
(16, '340ml', 0, '', 1),
(17, 'oo', 0, '', 1),
(18, 'df', 0, '', 1);

-- --------------------------------------------------------

--
-- 表的结构 `bc_item_view`
--

CREATE TABLE IF NOT EXISTS `bc_item_view` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(10) NOT NULL,
  `view` varchar(30) DEFAULT NULL COMMENT '外观描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=24 ;

--
-- 转存表中的数据 `bc_item_view`
--

INSERT INTO `bc_item_view` (`id`, `item_id`, `view`) VALUES
(8, 1, '4'),
(9, 1, '33er'),
(11, 0, '22'),
(12, 0, '纯红'),
(13, 0, '小猫'),
(14, 0, '小猫d'),
(15, 1, '狗爱民'),
(16, 2379, '默认外观'),
(17, 2380, '土豪金'),
(18, 2381, ''),
(19, 2383, '绿色'),
(20, 2383, '宝石蓝'),
(21, 2383, '黄色'),
(22, 2383, '红色'),
(23, 2391, 'df');

-- --------------------------------------------------------

--
-- 表的结构 `bc_source`
--

CREATE TABLE IF NOT EXISTS `bc_source` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `url` varchar(50) DEFAULT NULL,
  `country` varchar(30) DEFAULT NULL COMMENT '国家',
  `global_ship` tinyint(4) DEFAULT '0',
  `in_cn_en` tinyint(4) DEFAULT '0' COMMENT '中英文界面',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='货物来源表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `bc_stock`
--

CREATE TABLE IF NOT EXISTS `bc_stock` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(10) NOT NULL,
  `num` int(10) DEFAULT '0',
  `price` decimal(8,2) NOT NULL,
  `last_modify_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='库存表' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `bc_stock_log`
--

CREATE TABLE IF NOT EXISTS `bc_stock_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `item_id` int(10) NOT NULL,
  `is_in` tinyint(1) NOT NULL COMMENT '是否为入库，否表示出库',
  `object` varchar(30) DEFAULT NULL COMMENT '来源或去向',
  `time` int(11) NOT NULL,
  `operator` int(10) DEFAULT '0',
  `is_finished` tinyint(1) DEFAULT '1' COMMENT '操作是否完成',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='库存变化表' AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
