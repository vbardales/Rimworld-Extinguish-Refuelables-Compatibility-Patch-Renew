// Usage: node Art/render-preview.cjs. Requires Playwright and Sharp (bundled runtime).
const fs = require('fs'), path = require('path'), http = require('http');
const deps = process.env.CODEX_NODE_MODULES || path.join(process.env.USERPROFILE,'.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules');
const {chromium} = require(path.join(deps,'playwright'));
const sharp = require(path.join(deps,'sharp'));
const root = path.resolve(__dirname,'..');
const palette = JSON.parse(fs.readFileSync(path.join(__dirname,'preview-palette.json')));
const rgb = hex => hex.match(/\w\w/g).map(v=>parseInt(v,16));
const lum = c => c.map(v=>{v/=255;return v<=.04045?v/12.92:((v+.055)/1.055)**2.4}).reduce((a,v,i)=>a+v*[.2126,.7152,.0722][i],0);
const contrast = (a,b) => (Math.max(lum(a),lum(b))+.05)/(Math.min(lum(a),lum(b))+.05);
(async()=>{
 const server = http.createServer((req,res)=>{
  const file = path.resolve(root,'.'+decodeURIComponent(req.url.split('?')[0]));
  if(!file.startsWith(root+path.sep)) {res.writeHead(403).end();return;}
  fs.readFile(file,(err,data)=>{if(err){res.writeHead(404).end();return;}
   res.setHeader('Content-Type',({'.html':'text/html','.json':'application/json','.png':'image/png','.xml':'application/xml'})[path.extname(file)]||'text/plain');res.end(data);});
 });
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 let browser;
 try {
 browser = await chromium.launch({executablePath:'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
 const page = await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
 await page.goto(`http://127.0.0.1:${server.address().port}/Art/preview.html`);
 await page.evaluate(()=>window.ready);
 await page.locator('.frame').evaluate(async el=>{const img=new Image();img.src='Preview.png';await img.decode();});
 const cdp = await page.context().newCDPSession(page);
 await cdp.send('DOM.enable'); await cdp.send('CSS.enable');
 const {root:dom} = await cdp.send('DOM.getDocument');
 const fonts={};
 for(const selector of ['h1 .main','h1 .suffix','.tag','p','.version']) {
  const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:dom.nodeId,selector});
  fonts[selector]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;
  if(!fonts[selector].length || fonts[selector].some(f=>!f.familyName.startsWith('Segoe UI'))) throw Error('Unexpected actual font: '+JSON.stringify(fonts));
 }
 const boxes=await page.evaluate(()=>Object.fromEntries(['h1 .main','h1 .suffix','.tag','p','.version'].map(selector=>{
  const rects=[...document.querySelectorAll(selector)].flatMap(e=>[...e.getClientRects()].map(r=>({x:r.x,y:r.y,width:r.width,height:r.height})));
  return [selector,rects];
 })));
 const finalBuffer=await page.screenshot();
 await sharp(finalBuffer).png({compressionLevel:9}).toFile(path.join(root,'Mod/About/Preview.png'));
 await sharp(finalBuffer).resize(268).png().toFile(path.join(__dirname,'preview-268.png'));
 await page.evaluate(()=>document.body.classList.add('background-only'));
 const backdrop=await page.screenshot();
 await sharp(backdrop).png().toFile(path.join(__dirname,'preview-background.png'));
 const {data,info}=await sharp(backdrop).removeAlpha().raw().toBuffer({resolveWithObject:true});
 const results={};
 for(const [selector,rects] of Object.entries(boxes)) {
  const ink=rgb(selector.includes('suffix')||selector==='.tag'?palette.inkSecondary:selector==='.version'?palette.badgeInk:palette.inkPrimary);
  let minimum=Infinity;
  for(const r of rects) {
   if(r.x<0||r.y<0||r.x+r.width>896||r.y+r.height>504) throw Error('Text outside frame');
   for(let y=Math.floor(r.y);y<Math.ceil(r.y+r.height);y++)for(let x=Math.floor(r.x);x<Math.ceil(r.x+r.width);x++) {
    // Badge glyphs rotate within the triangle; check opaque badge ink/background directly.
    const bg=selector==='.version'?rgb(palette.accent):[...data.subarray((y*info.width+x)*3,(y*info.width+x)*3+3)];
    minimum=Math.min(minimum,contrast(ink,bg));
   }
  }
  results[selector]=Number(minimum.toFixed(3));
 }
 const report={dimensions:[896,504],bytes:fs.statSync(path.join(root,'Mod/About/Preview.png')).size,fonts,boxes,minimumContrastAcrossTextRectangles:results,version:await page.locator('.version').textContent()};
 fs.writeFileSync(path.join(__dirname,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
 if(report.bytes>=900000 || Object.values(results).some(v=>v<4.5)) throw Error('Preview QA failed');
 } finally {if(browser)await browser.close();await new Promise(r=>server.close(r));}
})().catch(e=>{console.error(e);process.exitCode=1});
