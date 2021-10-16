Vue.component('message', {
	template: '#message_template',
	data() {
	  return {};
	},
	computed: {
	  textEscaped() {
		let s = this.template ? this.template : this.templates[this.templateId];
  
		if (this.template) {
		  //We disable templateId since we are using a direct raw template
		  this.templateId = -1;
		}
  
		//This hack is required to preserve backwards compatability
		if (this.templateId == CONFIG.defaultTemplateId
			&& this.args.length == 1) {
		  s = this.templates[CONFIG.defaultAltTemplateId] //Swap out default template :/
		}
  
		s = s.replace(/{(\d+)}/g, (match, number) => {
		  const argEscaped = this.args[number] != undefined ? this.escape(this.args[number]) : match
		  if (number == 0 && this.color) {
			//color is deprecated, use templates or ^1 etc.
			return this.colorizeOld(argEscaped);
		  }
		  return argEscaped;
		});
		return this.colorize(s);
	  },
	},
	methods: {
	  colorizeOld(str) {
		return `<span style="color: rgb(${this.color[0]}, ${this.color[1]}, ${this.color[2]})">${str}</span>`
	  },
	  colorize(str) {
		let s = "<span>" + (str.replace(/\^([0-9a-z])/g, (str, color) => `</span><span class="color-${color}">`)) + "</span>";
		
  
		//console.log(s.replace(":1:", "<img src='https://cdn.discordapp.com/emojis/619977221951586320.png?v=1'></img>"));
  
		const styleDict = {
		  '*': 'font-weight: bold;',
		  '_': 'text-decoration: underline;',
		  '~': 'text-decoration: line-through;',
		  '=': 'text-decoration: underline line-through;',
		  'r': 'text-decoration: none;font-weight: normal;',
		};
  
		const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
		while (s.match(styleRegex)) { //Any better solution would be appreciated :P
		  s = s.replace(styleRegex, (str, style, inner) => `<em style="${styleDict[style]}">${inner}</em>`)
		}
		var s1 = s.replace(/<span[^>]*><\/span[^>]*>/g, '');
		var s2 = test1(s1);
		
		return s2;
	  },
	  escape(unsafe) {
		return String(unsafe)
		 .replace(/&/g, '&amp;')
		 .replace(/</g, '&lt;')
		 .replace(/>/g, '&gt;')
		 .replace(/"/g, '&quot;')
		 .replace(/'/g, '&#039;');
	  },
	},
	props: {
	  templates: {
		type: Object,
	  },
	  args: {
		type: Array,
	  },
	  template: {
		type: String,
		default: null,
	  },
	  templateId: {
		type: String,
		default: CONFIG.defaultTemplateId,
	  },
	  multiline: {
		type: Boolean,
		default: false,
	  },
	  color: { //deprecated
		type: Array,
		default: false,
	  },
	},
  });
  
  
  function test1(text) {
	  
	var emojRange = [
		["\:1:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/686270467056992314.png?v=1\"></img>"],
		["\:2:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/619977221951586320.png?v=1\"></img>"], 
		["\:3:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/619493231599681547.png?v=1\"></img>"], 
		["\:4:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/619975400377942036.png?v=1\"></img>"], 
		["\:5:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/619977214330535965.png?v=1\"></img>"], 
		["\:6:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/691581782570565633.png?v=1\"></img>"], 
		["\:7:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/653684058592641036.gif?v=1\"></img>"], 
		["\:8:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/650045493442772992.gif?v=1\"></img>"], 
		["\:9:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/696398099391840309.gif?v=1\"></img>"], 
		["\:10:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/711235867053654027.gif?v=1\"></img>"], 
		["\:11:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/650045492885061679.gif?v=1\"></img>"], 
		["\:12:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/650050802408488978.gif?v=1\"></img>"], 
		["\:13:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/653875017251160064.gif?v=1\"></img>"], 
		["\:14:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/650052291973349376.gif?v=1\"></img>"], 
		["\:15:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/650045493052702742.gif?v=1\"></img>"], 
		["\:16:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/629691136449052682.gif?v=1\"></img>"], 
		["\:17:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/676463639292674059.gif?v=1\"></img>"], 
		["\:18:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/664144634565492736.png?v=1\"></img>"], 
		["\:19:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/629556806712295435.gif?v=1\"></img>"], 
		["\:20:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/650050800311074874.gif?v=1\"></img>"], 
		["\:21:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/651090673709350912.gif?v=1\"></img>"], 
		["\:22:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/629580308731133952.gif?v=1\"></img>"], 
		["\:23:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/629576649599352853.gif?v=1\"></img>"], 
		["\:24:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/674791079001849856.gif?v=1\"></img>"], 
		["\:25:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/594437522260492318.gif?v=1\"></img>"], 
		["\:26:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/582891162709524500.gif?v=1\"></img>"], 
		["\:27:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/607041444863279137.gif?v=1\"></img>"], 
		["\:28:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/624235140713021460.gif?v=1\"></img>"], 
		["\:29:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/696378056876752937.png?v=1\"></img>"], 
		["\:30:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/685505214530453516.gif?v=1\"></img>"], 
		["\:31:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/718004381169090580.gif?v=1\"></img>"], 
		["\:32:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/696408548808327228.gif?v=1\"></img>"], 
		["\:33:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/683383446328049717.gif?v=1\"></img>"], 
		["\:34:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/513389703312048132.gif?v=1\"></img>"], 
		["\:35:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/696378344111079466.png?v=1\"></img>"], 
		["\:36:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/664100817908793374.png?v=1\"></img>"], 
		["\:37:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/664100817527111691.png?v=1\"></img>"], 
		["\:38:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/664834737554194432.gif?v=1\"></img>"], 
		["\:39:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/664834737398874142.gif?v=1\"></img>"], 
		["\:40:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/671397384139440138.png?v=1\"></img>"], 
		["\:41:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/683383669578268673.gif?v=1\"></img>"], 
		["\:42:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467721889021993.png?v=1\"></img>"], 
		["\:43:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467722144743500.png?v=1\"></img>"], 
		["\:44:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467721339699211.png?v=1\"></img>"], 
		["\:45:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467722102800445.png?v=1\"></img>"], 
		["\:46:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467722014982144.png?v=1\"></img>"], 
		["\:47:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467721977233439.png?v=1\"></img>"], 
		["\:48:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727468616399847434.png?v=1\"></img>"], 
		["\:49:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467776872153129.png?v=1\"></img>"], 
		["\:50:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467776742260758.png?v=1\"></img>"], 
		["\:51:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727468616198389852.png?v=1\"></img>"], 
		["\:52:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/727467848460402699.png?v=1\"></img>"], 
		["\:53:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/770927255802740737.gif?v=1\"></img>"], 
		["\:54:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/722405768443330611.png?v=1\"></img>"], 
		["\:55:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/829091523715006484.png?v=1\"></img>"], 
		["\:57:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/829237085197697055.png?v=1\"></img>"], 
		["\:58:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/823263095664541747.gif?v=1\"></img>"], 
		["\:59:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/821079184096755774.gif?v=1\"></img>"], 
		["\:60:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/722395644412559450.gif?v=1\"></img>"], 
		["\:61:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/813845952602308680.gif?v=1\"></img>"], 
		["\:62:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/782793674525638677.gif?v=1\"></img>"], 
		["\:63:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/750423666247991407.gif?v=1\"></img>"], 
		["\:64:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/827134081997078588.gif?v=1\"></img>"], 
		["\:65:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/684532211281690760.png?v=1\"></img>"], 
		["\:66:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/715033331980304394.gif?v=1\"></img>"], 
		["\:67:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/824773257776463912.gif?v=1\"></img>"], 
		["\:68:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/721904228620304521.png?v=1\"></img>"], 
		["\:69:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/824416826028982312.gif?v=1\"></img>"], 
		["\:70:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/699572558231633961.gif?v=1\"></img>"], 
		["\:71:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/826518088891629618.png?v=1\"></img>"], 
		["\:72:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/852114115144450058.png?v=1\"></img>"], 
		["\:73:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/851381831227146280.png?v=1\"></img>"], 
		["\:74:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/824497314496118811.png?v=1\"></img>"], 
		["\:76:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/851652102169690112.gif?v=1\"></img>"], 
		["\:77:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/851599660857950208.png?v=1\"></img>"], 
		["\:78:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/856607020958351360.gif?v=1\"></img>"], 
		["\:79:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/856607020190531584.gif?v=1\"></img>"], 
		["\:80:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/856607020723077170.gif?v=1\"></img>"], 
		["\:81:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/856607020723077170.gif?v=1\"></img>"], 
		["\:82:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/825150281686712360.png?v=1\"></img>"], 
		["\:83:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/865692136014872616.png?v=1\"></img>"], 
		["\:84:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/836388017693917184.gif?v=1\"></img>"], 
		["\:85:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/836387292930768926.gif?v=1\"></img>"], 
		["\:86:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/824417456327884861.png?v=1\"></img>"], 
		["\:87:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/825150295712989195.gif?v=1\"></img>"], 
		["\:88:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/825150294642917398.gif?v=1\"></img>"],
		["\:89:", "<img class=\"iconChat\" src=\"https://cdn.discordapp.com/emojis/825150287278637106.png?v=1\"></img>"],
		["\:90:", "<img class=\"iconChat\" src=\"https://i.imgur.com/yYXddU8.gif\"></img>"],
	];
	var finalText = text;
  
	  for (var i = 0; i < emojRange.length; i++) {
		  var range = emojRange[i];
		  var re = new RegExp(range[0], "g");
		  //finalText = finalText.replaceAll(range[0], range[1]);
		  finalText = finalText.replace(re,range[1]);
		  
	  }
	  
	  //console.log(finalText);
	  
	  return finalText;
  }