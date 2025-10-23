var Jt=Object.defineProperty;var Ke=e=>{throw TypeError(e)};var Ft=(e,t,r)=>t in e?Jt(e,t,{enumerable:!0,configurable:!0,writable:!0,value:r}):e[t]=r;var g=(e,t,r)=>Ft(e,typeof t!="symbol"?t+"":t,r),He=(e,t,r)=>t.has(e)||Ke("Cannot "+r);var c=(e,t,r)=>(He(e,t,"read from private field"),r?r.call(e):t.get(e)),m=(e,t,r)=>t.has(e)?Ke("Cannot add the same private member more than once"):t instanceof WeakSet?t.add(e):t.set(e,r),p=(e,t,r,s)=>(He(e,t,"write to private field"),s?s.call(e,r):t.set(e,r),r),b=(e,t,r)=>(He(e,t,"access private method"),r);var Ve=(e,t,r,s)=>({set _(a){p(e,t,a,r)},get _(){return c(e,t,s)}});var Ge=(e,t,r)=>(s,a)=>{let n=-1;return o(0);async function o(i){if(i<=n)throw new Error("next() called multiple times");n=i;let l,d=!1,u;if(e[i]?(u=e[i][0][0],s.req.routeIndex=i):u=i===e.length&&a||void 0,u)try{l=await u(s,()=>o(i+1))}catch(f){if(f instanceof Error&&t)s.error=f,l=await t(f,s),d=!0;else throw f}else s.finalized===!1&&r&&(l=await r(s));return l&&(s.finalized===!1||d)&&(s.res=l),s}},Ut=Symbol(),qt=async(e,t=Object.create(null))=>{const{all:r=!1,dot:s=!1}=t,n=(e instanceof ht?e.raw.headers:e.headers).get("Content-Type");return n!=null&&n.startsWith("multipart/form-data")||n!=null&&n.startsWith("application/x-www-form-urlencoded")?Wt(e,{all:r,dot:s}):{}};async function Wt(e,t){const r=await e.formData();return r?Kt(r,t):{}}function Kt(e,t){const r=Object.create(null);return e.forEach((s,a)=>{t.all||a.endsWith("[]")?Vt(r,a,s):r[a]=s}),t.dot&&Object.entries(r).forEach(([s,a])=>{s.includes(".")&&(Gt(r,s,a),delete r[s])}),r}var Vt=(e,t,r)=>{e[t]!==void 0?Array.isArray(e[t])?e[t].push(r):e[t]=[e[t],r]:t.endsWith("[]")?e[t]=[r]:e[t]=r},Gt=(e,t,r)=>{let s=e;const a=t.split(".");a.forEach((n,o)=>{o===a.length-1?s[n]=r:((!s[n]||typeof s[n]!="object"||Array.isArray(s[n])||s[n]instanceof File)&&(s[n]=Object.create(null)),s=s[n])})},ut=e=>{const t=e.split("/");return t[0]===""&&t.shift(),t},Yt=e=>{const{groups:t,path:r}=Xt(e),s=ut(r);return Qt(s,t)},Xt=e=>{const t=[];return e=e.replace(/\{[^}]+\}/g,(r,s)=>{const a=`@${s}`;return t.push([a,r]),a}),{groups:t,path:e}},Qt=(e,t)=>{for(let r=t.length-1;r>=0;r--){const[s]=t[r];for(let a=e.length-1;a>=0;a--)if(e[a].includes(s)){e[a]=e[a].replace(s,t[r][1]);break}}return e},je={},Zt=(e,t)=>{if(e==="*")return"*";const r=e.match(/^\:([^\{\}]+)(?:\{(.+)\})?$/);if(r){const s=`${e}#${t}`;return je[s]||(r[2]?je[s]=t&&t[0]!==":"&&t[0]!=="*"?[s,r[1],new RegExp(`^${r[2]}(?=/${t})`)]:[e,r[1],new RegExp(`^${r[2]}$`)]:je[s]=[e,r[1],!0]),je[s]}return null},Ce=(e,t)=>{try{return t(e)}catch{return e.replace(/(?:%[0-9A-Fa-f]{2})+/g,r=>{try{return t(r)}catch{return r}})}},er=e=>Ce(e,decodeURI),ft=e=>{const t=e.url,r=t.indexOf("/",t.indexOf(":")+4);let s=r;for(;s<t.length;s++){const a=t.charCodeAt(s);if(a===37){const n=t.indexOf("?",s),o=t.slice(r,n===-1?void 0:n);return er(o.includes("%25")?o.replace(/%25/g,"%2525"):o)}else if(a===63)break}return t.slice(r,s)},tr=e=>{const t=ft(e);return t.length>1&&t.at(-1)==="/"?t.slice(0,-1):t},re=(e,t,...r)=>(r.length&&(t=re(t,...r)),`${(e==null?void 0:e[0])==="/"?"":"/"}${e}${t==="/"?"":`${(e==null?void 0:e.at(-1))==="/"?"":"/"}${(t==null?void 0:t[0])==="/"?t.slice(1):t}`}`),pt=e=>{if(e.charCodeAt(e.length-1)!==63||!e.includes(":"))return null;const t=e.split("/"),r=[];let s="";return t.forEach(a=>{if(a!==""&&!/\:/.test(a))s+="/"+a;else if(/\:/.test(a))if(/\?/.test(a)){r.length===0&&s===""?r.push("/"):r.push(s);const n=a.replace("?","");s+="/"+n,r.push(s)}else s+="/"+a}),r.filter((a,n,o)=>o.indexOf(a)===n)},De=e=>/[%+]/.test(e)?(e.indexOf("+")!==-1&&(e=e.replace(/\+/g," ")),e.indexOf("%")!==-1?Ce(e,Fe):e):e,gt=(e,t,r)=>{let s;if(!r&&t&&!/[%+]/.test(t)){let o=e.indexOf(`?${t}`,8);for(o===-1&&(o=e.indexOf(`&${t}`,8));o!==-1;){const i=e.charCodeAt(o+t.length+1);if(i===61){const l=o+t.length+2,d=e.indexOf("&",l);return De(e.slice(l,d===-1?void 0:d))}else if(i==38||isNaN(i))return"";o=e.indexOf(`&${t}`,o+1)}if(s=/[%+]/.test(e),!s)return}const a={};s??(s=/[%+]/.test(e));let n=e.indexOf("?",8);for(;n!==-1;){const o=e.indexOf("&",n+1);let i=e.indexOf("=",n);i>o&&o!==-1&&(i=-1);let l=e.slice(n+1,i===-1?o===-1?void 0:o:i);if(s&&(l=De(l)),n=o,l==="")continue;let d;i===-1?d="":(d=e.slice(i+1,o===-1?void 0:o),s&&(d=De(d))),r?(a[l]&&Array.isArray(a[l])||(a[l]=[]),a[l].push(d)):a[l]??(a[l]=d)}return t?a[t]:a},rr=gt,sr=(e,t)=>gt(e,t,!0),Fe=decodeURIComponent,Ye=e=>Ce(e,Fe),ne,I,B,mt,bt,Le,z,rt,ht=(rt=class{constructor(e,t="/",r=[[]]){m(this,B);g(this,"raw");m(this,ne);m(this,I);g(this,"routeIndex",0);g(this,"path");g(this,"bodyCache",{});m(this,z,e=>{const{bodyCache:t,raw:r}=this,s=t[e];if(s)return s;const a=Object.keys(t)[0];return a?t[a].then(n=>(a==="json"&&(n=JSON.stringify(n)),new Response(n)[e]())):t[e]=r[e]()});this.raw=e,this.path=t,p(this,I,r),p(this,ne,{})}param(e){return e?b(this,B,mt).call(this,e):b(this,B,bt).call(this)}query(e){return rr(this.url,e)}queries(e){return sr(this.url,e)}header(e){if(e)return this.raw.headers.get(e)??void 0;const t={};return this.raw.headers.forEach((r,s)=>{t[s]=r}),t}async parseBody(e){var t;return(t=this.bodyCache).parsedBody??(t.parsedBody=await qt(this,e))}json(){return c(this,z).call(this,"text").then(e=>JSON.parse(e))}text(){return c(this,z).call(this,"text")}arrayBuffer(){return c(this,z).call(this,"arrayBuffer")}blob(){return c(this,z).call(this,"blob")}formData(){return c(this,z).call(this,"formData")}addValidatedData(e,t){c(this,ne)[e]=t}valid(e){return c(this,ne)[e]}get url(){return this.raw.url}get method(){return this.raw.method}get[Ut](){return c(this,I)}get matchedRoutes(){return c(this,I)[0].map(([[,e]])=>e)}get routePath(){return c(this,I)[0].map(([[,e]])=>e)[this.routeIndex].path}},ne=new WeakMap,I=new WeakMap,B=new WeakSet,mt=function(e){const t=c(this,I)[0][this.routeIndex][1][e],r=b(this,B,Le).call(this,t);return r&&/\%/.test(r)?Ye(r):r},bt=function(){const e={},t=Object.keys(c(this,I)[0][this.routeIndex][1]);for(const r of t){const s=b(this,B,Le).call(this,c(this,I)[0][this.routeIndex][1][r]);s!==void 0&&(e[r]=/\%/.test(s)?Ye(s):s)}return e},Le=function(e){return c(this,I)[1]?c(this,I)[1][e]:e},z=new WeakMap,rt),ar={Stringify:1},xt=async(e,t,r,s,a)=>{typeof e=="object"&&!(e instanceof String)&&(e instanceof Promise||(e=e.toString()),e instanceof Promise&&(e=await e));const n=e.callbacks;return n!=null&&n.length?(a?a[0]+=e:a=[e],Promise.all(n.map(i=>i({phase:t,buffer:a,context:s}))).then(i=>Promise.all(i.filter(Boolean).map(l=>xt(l,t,!1,s,a))).then(()=>a[0]))):Promise.resolve(e)},nr="text/plain; charset=UTF-8",Oe=(e,t)=>({"Content-Type":e,...t}),me,be,D,oe,O,k,xe,ie,le,G,ve,ye,J,se,st,or=(st=class{constructor(e,t){m(this,J);m(this,me);m(this,be);g(this,"env",{});m(this,D);g(this,"finalized",!1);g(this,"error");m(this,oe);m(this,O);m(this,k);m(this,xe);m(this,ie);m(this,le);m(this,G);m(this,ve);m(this,ye);g(this,"render",(...e)=>(c(this,ie)??p(this,ie,t=>this.html(t)),c(this,ie).call(this,...e)));g(this,"setLayout",e=>p(this,xe,e));g(this,"getLayout",()=>c(this,xe));g(this,"setRenderer",e=>{p(this,ie,e)});g(this,"header",(e,t,r)=>{this.finalized&&p(this,k,new Response(c(this,k).body,c(this,k)));const s=c(this,k)?c(this,k).headers:c(this,G)??p(this,G,new Headers);t===void 0?s.delete(e):r!=null&&r.append?s.append(e,t):s.set(e,t)});g(this,"status",e=>{p(this,oe,e)});g(this,"set",(e,t)=>{c(this,D)??p(this,D,new Map),c(this,D).set(e,t)});g(this,"get",e=>c(this,D)?c(this,D).get(e):void 0);g(this,"newResponse",(...e)=>b(this,J,se).call(this,...e));g(this,"body",(e,t,r)=>b(this,J,se).call(this,e,t,r));g(this,"text",(e,t,r)=>!c(this,G)&&!c(this,oe)&&!t&&!r&&!this.finalized?new Response(e):b(this,J,se).call(this,e,t,Oe(nr,r)));g(this,"json",(e,t,r)=>b(this,J,se).call(this,JSON.stringify(e),t,Oe("application/json",r)));g(this,"html",(e,t,r)=>{const s=a=>b(this,J,se).call(this,a,t,Oe("text/html; charset=UTF-8",r));return typeof e=="object"?xt(e,ar.Stringify,!1,{}).then(s):s(e)});g(this,"redirect",(e,t)=>{const r=String(e);return this.header("Location",/[^\x00-\xFF]/.test(r)?encodeURI(r):r),this.newResponse(null,t??302)});g(this,"notFound",()=>(c(this,le)??p(this,le,()=>new Response),c(this,le).call(this,this)));p(this,me,e),t&&(p(this,O,t.executionCtx),this.env=t.env,p(this,le,t.notFoundHandler),p(this,ye,t.path),p(this,ve,t.matchResult))}get req(){return c(this,be)??p(this,be,new ht(c(this,me),c(this,ye),c(this,ve))),c(this,be)}get event(){if(c(this,O)&&"respondWith"in c(this,O))return c(this,O);throw Error("This context has no FetchEvent")}get executionCtx(){if(c(this,O))return c(this,O);throw Error("This context has no ExecutionContext")}get res(){return c(this,k)||p(this,k,new Response(null,{headers:c(this,G)??p(this,G,new Headers)}))}set res(e){if(c(this,k)&&e){e=new Response(e.body,e);for(const[t,r]of c(this,k).headers.entries())if(t!=="content-type")if(t==="set-cookie"){const s=c(this,k).headers.getSetCookie();e.headers.delete("set-cookie");for(const a of s)e.headers.append("set-cookie",a)}else e.headers.set(t,r)}p(this,k,e),this.finalized=!0}get var(){return c(this,D)?Object.fromEntries(c(this,D)):{}}},me=new WeakMap,be=new WeakMap,D=new WeakMap,oe=new WeakMap,O=new WeakMap,k=new WeakMap,xe=new WeakMap,ie=new WeakMap,le=new WeakMap,G=new WeakMap,ve=new WeakMap,ye=new WeakMap,J=new WeakSet,se=function(e,t,r){const s=c(this,k)?new Headers(c(this,k).headers):c(this,G)??new Headers;if(typeof t=="object"&&"headers"in t){const n=t.headers instanceof Headers?t.headers:new Headers(t.headers);for(const[o,i]of n)o.toLowerCase()==="set-cookie"?s.append(o,i):s.set(o,i)}if(r)for(const[n,o]of Object.entries(r))if(typeof o=="string")s.set(n,o);else{s.delete(n);for(const i of o)s.append(n,i)}const a=typeof t=="number"?t:(t==null?void 0:t.status)??c(this,oe);return new Response(e,{status:a,headers:s})},st),w="ALL",ir="all",lr=["get","post","put","delete","options","patch"],vt="Can not add a route since the matcher is already built.",yt=class extends Error{},cr="__COMPOSED_HANDLER",dr=e=>e.text("404 Not Found",404),Xe=(e,t)=>{if("getResponse"in e){const r=e.getResponse();return t.newResponse(r.body,r)}return console.error(e),t.text("Internal Server Error",500)},T,E,Et,C,K,Re,Ae,at,wt=(at=class{constructor(t={}){m(this,E);g(this,"get");g(this,"post");g(this,"put");g(this,"delete");g(this,"options");g(this,"patch");g(this,"all");g(this,"on");g(this,"use");g(this,"router");g(this,"getPath");g(this,"_basePath","/");m(this,T,"/");g(this,"routes",[]);m(this,C,dr);g(this,"errorHandler",Xe);g(this,"onError",t=>(this.errorHandler=t,this));g(this,"notFound",t=>(p(this,C,t),this));g(this,"fetch",(t,...r)=>b(this,E,Ae).call(this,t,r[1],r[0],t.method));g(this,"request",(t,r,s,a)=>t instanceof Request?this.fetch(r?new Request(t,r):t,s,a):(t=t.toString(),this.fetch(new Request(/^https?:\/\//.test(t)?t:`http://localhost${re("/",t)}`,r),s,a)));g(this,"fire",()=>{addEventListener("fetch",t=>{t.respondWith(b(this,E,Ae).call(this,t.request,t,void 0,t.request.method))})});[...lr,ir].forEach(n=>{this[n]=(o,...i)=>(typeof o=="string"?p(this,T,o):b(this,E,K).call(this,n,c(this,T),o),i.forEach(l=>{b(this,E,K).call(this,n,c(this,T),l)}),this)}),this.on=(n,o,...i)=>{for(const l of[o].flat()){p(this,T,l);for(const d of[n].flat())i.map(u=>{b(this,E,K).call(this,d.toUpperCase(),c(this,T),u)})}return this},this.use=(n,...o)=>(typeof n=="string"?p(this,T,n):(p(this,T,"*"),o.unshift(n)),o.forEach(i=>{b(this,E,K).call(this,w,c(this,T),i)}),this);const{strict:s,...a}=t;Object.assign(this,a),this.getPath=s??!0?t.getPath??ft:tr}route(t,r){const s=this.basePath(t);return r.routes.map(a=>{var o;let n;r.errorHandler===Xe?n=a.handler:(n=async(i,l)=>(await Ge([],r.errorHandler)(i,()=>a.handler(i,l))).res,n[cr]=a.handler),b(o=s,E,K).call(o,a.method,a.path,n)}),this}basePath(t){const r=b(this,E,Et).call(this);return r._basePath=re(this._basePath,t),r}mount(t,r,s){let a,n;s&&(typeof s=="function"?n=s:(n=s.optionHandler,s.replaceRequest===!1?a=l=>l:a=s.replaceRequest));const o=n?l=>{const d=n(l);return Array.isArray(d)?d:[d]}:l=>{let d;try{d=l.executionCtx}catch{}return[l.env,d]};a||(a=(()=>{const l=re(this._basePath,t),d=l==="/"?0:l.length;return u=>{const f=new URL(u.url);return f.pathname=f.pathname.slice(d)||"/",new Request(f,u)}})());const i=async(l,d)=>{const u=await r(a(l.req.raw),...o(l));if(u)return u;await d()};return b(this,E,K).call(this,w,re(t,"*"),i),this}},T=new WeakMap,E=new WeakSet,Et=function(){const t=new wt({router:this.router,getPath:this.getPath});return t.errorHandler=this.errorHandler,p(t,C,c(this,C)),t.routes=this.routes,t},C=new WeakMap,K=function(t,r,s){t=t.toUpperCase(),r=re(this._basePath,r);const a={basePath:this._basePath,path:r,method:t,handler:s};this.router.add(t,r,[s,a]),this.routes.push(a)},Re=function(t,r){if(t instanceof Error)return this.errorHandler(t,r);throw t},Ae=function(t,r,s,a){if(a==="HEAD")return(async()=>new Response(null,await b(this,E,Ae).call(this,t,r,s,"GET")))();const n=this.getPath(t,{env:s}),o=this.router.match(a,n),i=new or(t,{path:n,matchResult:o,env:s,executionCtx:r,notFoundHandler:c(this,C)});if(o[0].length===1){let d;try{d=o[0][0][0][0](i,async()=>{i.res=await c(this,C).call(this,i)})}catch(u){return b(this,E,Re).call(this,u,i)}return d instanceof Promise?d.then(u=>u||(i.finalized?i.res:c(this,C).call(this,i))).catch(u=>b(this,E,Re).call(this,u,i)):d??c(this,C).call(this,i)}const l=Ge(o[0],this.errorHandler,c(this,C));return(async()=>{try{const d=await l(i);if(!d.finalized)throw new Error("Context is not finalized. Did you forget to return a Response object or `await next()`?");return d.res}catch(d){return b(this,E,Re).call(this,d,i)}})()},at),St=[];function ur(e,t){const r=this.buildAllMatchers(),s=(a,n)=>{const o=r[a]||r[w],i=o[2][n];if(i)return i;const l=n.match(o[0]);if(!l)return[[],St];const d=l.indexOf("",1);return[o[1][d],l]};return this.match=s,s(e,t)}var Pe="[^/]+",pe=".*",ge="(?:|/.*)",ae=Symbol(),fr=new Set(".\\+*[^]$()");function pr(e,t){return e.length===1?t.length===1?e<t?-1:1:-1:t.length===1||e===pe||e===ge?1:t===pe||t===ge?-1:e===Pe?1:t===Pe?-1:e.length===t.length?e<t?-1:1:t.length-e.length}var Y,X,$,nt,ze=(nt=class{constructor(){m(this,Y);m(this,X);m(this,$,Object.create(null))}insert(t,r,s,a,n){if(t.length===0){if(c(this,Y)!==void 0)throw ae;if(n)return;p(this,Y,r);return}const[o,...i]=t,l=o==="*"?i.length===0?["","",pe]:["","",Pe]:o==="/*"?["","",ge]:o.match(/^\:([^\{\}]+)(?:\{(.+)\})?$/);let d;if(l){const u=l[1];let f=l[2]||Pe;if(u&&l[2]&&(f===".*"||(f=f.replace(/^\((?!\?:)(?=[^)]+\)$)/,"(?:"),/\((?!\?:)/.test(f))))throw ae;if(d=c(this,$)[f],!d){if(Object.keys(c(this,$)).some(h=>h!==pe&&h!==ge))throw ae;if(n)return;d=c(this,$)[f]=new ze,u!==""&&p(d,X,a.varIndex++)}!n&&u!==""&&s.push([u,c(d,X)])}else if(d=c(this,$)[o],!d){if(Object.keys(c(this,$)).some(u=>u.length>1&&u!==pe&&u!==ge))throw ae;if(n)return;d=c(this,$)[o]=new ze}d.insert(i,r,s,a,n)}buildRegExpStr(){const r=Object.keys(c(this,$)).sort(pr).map(s=>{const a=c(this,$)[s];return(typeof c(a,X)=="number"?`(${s})@${c(a,X)}`:fr.has(s)?`\\${s}`:s)+a.buildRegExpStr()});return typeof c(this,Y)=="number"&&r.unshift(`#${c(this,Y)}`),r.length===0?"":r.length===1?r[0]:"(?:"+r.join("|")+")"}},Y=new WeakMap,X=new WeakMap,$=new WeakMap,nt),Ie,we,ot,gr=(ot=class{constructor(){m(this,Ie,{varIndex:0});m(this,we,new ze)}insert(e,t,r){const s=[],a=[];for(let o=0;;){let i=!1;if(e=e.replace(/\{[^}]+\}/g,l=>{const d=`@\\${o}`;return a[o]=[d,l],o++,i=!0,d}),!i)break}const n=e.match(/(?::[^\/]+)|(?:\/\*$)|./g)||[];for(let o=a.length-1;o>=0;o--){const[i]=a[o];for(let l=n.length-1;l>=0;l--)if(n[l].indexOf(i)!==-1){n[l]=n[l].replace(i,a[o][1]);break}}return c(this,we).insert(n,t,s,c(this,Ie),r),s}buildRegExp(){let e=c(this,we).buildRegExpStr();if(e==="")return[/^$/,[],[]];let t=0;const r=[],s=[];return e=e.replace(/#(\d+)|@(\d+)|\.\*\$/g,(a,n,o)=>n!==void 0?(r[++t]=Number(n),"$()"):(o!==void 0&&(s[Number(o)]=++t),"")),[new RegExp(`^${e}`),r,s]}},Ie=new WeakMap,we=new WeakMap,ot),hr=[/^$/,[],Object.create(null)],ke=Object.create(null);function jt(e){return ke[e]??(ke[e]=new RegExp(e==="*"?"":`^${e.replace(/\/\*$|([.\\+*[^\]$()])/g,(t,r)=>r?`\\${r}`:"(?:|/.*)")}$`))}function mr(){ke=Object.create(null)}function br(e){var d;const t=new gr,r=[];if(e.length===0)return hr;const s=e.map(u=>[!/\*|\/:/.test(u[0]),...u]).sort(([u,f],[h,x])=>u?1:h?-1:f.length-x.length),a=Object.create(null);for(let u=0,f=-1,h=s.length;u<h;u++){const[x,P,v]=s[u];x?a[P]=[v.map(([A])=>[A,Object.create(null)]),St]:f++;let y;try{y=t.insert(P,f,x)}catch(A){throw A===ae?new yt(P):A}x||(r[f]=v.map(([A,ee])=>{const de=Object.create(null);for(ee-=1;ee>=0;ee--){const[M,$e]=y[ee];de[M]=$e}return[A,de]}))}const[n,o,i]=t.buildRegExp();for(let u=0,f=r.length;u<f;u++)for(let h=0,x=r[u].length;h<x;h++){const P=(d=r[u][h])==null?void 0:d[1];if(!P)continue;const v=Object.keys(P);for(let y=0,A=v.length;y<A;y++)P[v[y]]=i[P[v[y]]]}const l=[];for(const u in o)l[u]=r[o[u]];return[n,l,a]}function te(e,t){if(e){for(const r of Object.keys(e).sort((s,a)=>a.length-s.length))if(jt(r).test(t))return[...e[r]]}}var F,U,Te,Rt,it,xr=(it=class{constructor(){m(this,Te);g(this,"name","RegExpRouter");m(this,F);m(this,U);g(this,"match",ur);p(this,F,{[w]:Object.create(null)}),p(this,U,{[w]:Object.create(null)})}add(e,t,r){var i;const s=c(this,F),a=c(this,U);if(!s||!a)throw new Error(vt);s[e]||[s,a].forEach(l=>{l[e]=Object.create(null),Object.keys(l[w]).forEach(d=>{l[e][d]=[...l[w][d]]})}),t==="/*"&&(t="*");const n=(t.match(/\/:/g)||[]).length;if(/\*$/.test(t)){const l=jt(t);e===w?Object.keys(s).forEach(d=>{var u;(u=s[d])[t]||(u[t]=te(s[d],t)||te(s[w],t)||[])}):(i=s[e])[t]||(i[t]=te(s[e],t)||te(s[w],t)||[]),Object.keys(s).forEach(d=>{(e===w||e===d)&&Object.keys(s[d]).forEach(u=>{l.test(u)&&s[d][u].push([r,n])})}),Object.keys(a).forEach(d=>{(e===w||e===d)&&Object.keys(a[d]).forEach(u=>l.test(u)&&a[d][u].push([r,n]))});return}const o=pt(t)||[t];for(let l=0,d=o.length;l<d;l++){const u=o[l];Object.keys(a).forEach(f=>{var h;(e===w||e===f)&&((h=a[f])[u]||(h[u]=[...te(s[f],u)||te(s[w],u)||[]]),a[f][u].push([r,n-d+l+1]))})}}buildAllMatchers(){const e=Object.create(null);return Object.keys(c(this,U)).concat(Object.keys(c(this,F))).forEach(t=>{e[t]||(e[t]=b(this,Te,Rt).call(this,t))}),p(this,F,p(this,U,void 0)),mr(),e}},F=new WeakMap,U=new WeakMap,Te=new WeakSet,Rt=function(e){const t=[];let r=e===w;return[c(this,F),c(this,U)].forEach(s=>{const a=s[e]?Object.keys(s[e]).map(n=>[n,s[e][n]]):[];a.length!==0?(r||(r=!0),t.push(...a)):e!==w&&t.push(...Object.keys(s[w]).map(n=>[n,s[w][n]]))}),r?br(t):null},it),q,_,lt,vr=(lt=class{constructor(e){g(this,"name","SmartRouter");m(this,q,[]);m(this,_,[]);p(this,q,e.routers)}add(e,t,r){if(!c(this,_))throw new Error(vt);c(this,_).push([e,t,r])}match(e,t){if(!c(this,_))throw new Error("Fatal error");const r=c(this,q),s=c(this,_),a=r.length;let n=0,o;for(;n<a;n++){const i=r[n];try{for(let l=0,d=s.length;l<d;l++)i.add(...s[l]);o=i.match(e,t)}catch(l){if(l instanceof yt)continue;throw l}this.match=i.match.bind(i),p(this,q,[i]),p(this,_,void 0);break}if(n===a)throw new Error("Fatal error");return this.name=`SmartRouter + ${this.activeRouter.name}`,o}get activeRouter(){if(c(this,_)||c(this,q).length!==1)throw new Error("No active router has been determined yet.");return c(this,q)[0]}},q=new WeakMap,_=new WeakMap,lt),fe=Object.create(null),W,R,Q,ce,j,N,V,ct,At=(ct=class{constructor(e,t,r){m(this,N);m(this,W);m(this,R);m(this,Q);m(this,ce,0);m(this,j,fe);if(p(this,R,r||Object.create(null)),p(this,W,[]),e&&t){const s=Object.create(null);s[e]={handler:t,possibleKeys:[],score:0},p(this,W,[s])}p(this,Q,[])}insert(e,t,r){p(this,ce,++Ve(this,ce)._);let s=this;const a=Yt(t),n=[];for(let o=0,i=a.length;o<i;o++){const l=a[o],d=a[o+1],u=Zt(l,d),f=Array.isArray(u)?u[0]:l;if(f in c(s,R)){s=c(s,R)[f],u&&n.push(u[1]);continue}c(s,R)[f]=new At,u&&(c(s,Q).push(u),n.push(u[1])),s=c(s,R)[f]}return c(s,W).push({[e]:{handler:r,possibleKeys:n.filter((o,i,l)=>l.indexOf(o)===i),score:c(this,ce)}}),s}search(e,t){var i;const r=[];p(this,j,fe);let a=[this];const n=ut(t),o=[];for(let l=0,d=n.length;l<d;l++){const u=n[l],f=l===d-1,h=[];for(let x=0,P=a.length;x<P;x++){const v=a[x],y=c(v,R)[u];y&&(p(y,j,c(v,j)),f?(c(y,R)["*"]&&r.push(...b(this,N,V).call(this,c(y,R)["*"],e,c(v,j))),r.push(...b(this,N,V).call(this,y,e,c(v,j)))):h.push(y));for(let A=0,ee=c(v,Q).length;A<ee;A++){const de=c(v,Q)[A],M=c(v,j)===fe?{}:{...c(v,j)};if(de==="*"){const L=c(v,R)["*"];L&&(r.push(...b(this,N,V).call(this,L,e,c(v,j))),p(L,j,M),h.push(L));continue}const[$e,We,ue]=de;if(!u&&!(ue instanceof RegExp))continue;const H=c(v,R)[$e],zt=n.slice(l).join("/");if(ue instanceof RegExp){const L=ue.exec(zt);if(L){if(M[We]=L[0],r.push(...b(this,N,V).call(this,H,e,c(v,j),M)),Object.keys(c(H,R)).length){p(H,j,M);const Me=((i=L[0].match(/\//))==null?void 0:i.length)??0;(o[Me]||(o[Me]=[])).push(H)}continue}}(ue===!0||ue.test(u))&&(M[We]=u,f?(r.push(...b(this,N,V).call(this,H,e,M,c(v,j))),c(H,R)["*"]&&r.push(...b(this,N,V).call(this,c(H,R)["*"],e,M,c(v,j)))):(p(H,j,M),h.push(H)))}}a=h.concat(o.shift()??[])}return r.length>1&&r.sort((l,d)=>l.score-d.score),[r.map(({handler:l,params:d})=>[l,d])]}},W=new WeakMap,R=new WeakMap,Q=new WeakMap,ce=new WeakMap,j=new WeakMap,N=new WeakSet,V=function(e,t,r,s){const a=[];for(let n=0,o=c(e,W).length;n<o;n++){const i=c(e,W)[n],l=i[t]||i[w],d={};if(l!==void 0&&(l.params=Object.create(null),a.push(l),r!==fe||s&&s!==fe))for(let u=0,f=l.possibleKeys.length;u<f;u++){const h=l.possibleKeys[u],x=d[l.score];l.params[h]=s!=null&&s[h]&&!x?s[h]:r[h]??(s==null?void 0:s[h]),d[l.score]=!0}}return a},ct),Z,dt,yr=(dt=class{constructor(){g(this,"name","TrieRouter");m(this,Z);p(this,Z,new At)}add(e,t,r){const s=pt(t);if(s){for(let a=0,n=s.length;a<n;a++)c(this,Z).insert(e,s[a],r);return}c(this,Z).insert(e,t,r)}match(e,t){return c(this,Z).search(e,t)}},Z=new WeakMap,dt),kt=class extends wt{constructor(e={}){super(e),this.router=e.router??new vr({routers:[new xr,new yr]})}},wr=e=>{const r={...{origin:"*",allowMethods:["GET","HEAD","PUT","POST","DELETE","PATCH"],allowHeaders:[],exposeHeaders:[]},...e},s=(n=>typeof n=="string"?n==="*"?()=>n:o=>n===o?o:null:typeof n=="function"?n:o=>n.includes(o)?o:null)(r.origin),a=(n=>typeof n=="function"?n:Array.isArray(n)?()=>n:()=>[])(r.allowMethods);return async function(o,i){var u;function l(f,h){o.res.headers.set(f,h)}const d=await s(o.req.header("origin")||"",o);if(d&&l("Access-Control-Allow-Origin",d),r.origin!=="*"){const f=o.req.header("Vary");f?l("Vary",f):l("Vary","Origin")}if(r.credentials&&l("Access-Control-Allow-Credentials","true"),(u=r.exposeHeaders)!=null&&u.length&&l("Access-Control-Expose-Headers",r.exposeHeaders.join(",")),o.req.method==="OPTIONS"){r.maxAge!=null&&l("Access-Control-Max-Age",r.maxAge.toString());const f=await a(o.req.header("origin")||"",o);f.length&&l("Access-Control-Allow-Methods",f.join(","));let h=r.allowHeaders;if(!(h!=null&&h.length)){const x=o.req.header("Access-Control-Request-Headers");x&&(h=x.split(/\s*,\s*/))}return h!=null&&h.length&&(l("Access-Control-Allow-Headers",h.join(",")),o.res.headers.append("Vary","Access-Control-Request-Headers")),o.res.headers.delete("Content-Length"),o.res.headers.delete("Content-Type"),new Response(null,{headers:o.res.headers,status:204,statusText:"No Content"})}await i()}},Er=/^\s*(?:text\/(?!event-stream(?:[;\s]|$))[^;\s]+|application\/(?:javascript|json|xml|xml-dtd|ecmascript|dart|postscript|rtf|tar|toml|vnd\.dart|vnd\.ms-fontobject|vnd\.ms-opentype|wasm|x-httpd-php|x-javascript|x-ns-proxy-autoconfig|x-sh|x-tar|x-virtualbox-hdd|x-virtualbox-ova|x-virtualbox-ovf|x-virtualbox-vbox|x-virtualbox-vdi|x-virtualbox-vhd|x-virtualbox-vmdk|x-www-form-urlencoded)|font\/(?:otf|ttf)|image\/(?:bmp|vnd\.adobe\.photoshop|vnd\.microsoft\.icon|vnd\.ms-dds|x-icon|x-ms-bmp)|message\/rfc822|model\/gltf-binary|x-shader\/x-fragment|x-shader\/x-vertex|[^;\s]+?\+(?:json|text|xml|yaml))(?:[;\s]|$)/i,Qe=(e,t=jr)=>{const r=/\.([a-zA-Z0-9]+?)$/,s=e.match(r);if(!s)return;let a=t[s[1]];return a&&a.startsWith("text")&&(a+="; charset=utf-8"),a},Sr={aac:"audio/aac",avi:"video/x-msvideo",avif:"image/avif",av1:"video/av1",bin:"application/octet-stream",bmp:"image/bmp",css:"text/css",csv:"text/csv",eot:"application/vnd.ms-fontobject",epub:"application/epub+zip",gif:"image/gif",gz:"application/gzip",htm:"text/html",html:"text/html",ico:"image/x-icon",ics:"text/calendar",jpeg:"image/jpeg",jpg:"image/jpeg",js:"text/javascript",json:"application/json",jsonld:"application/ld+json",map:"application/json",mid:"audio/x-midi",midi:"audio/x-midi",mjs:"text/javascript",mp3:"audio/mpeg",mp4:"video/mp4",mpeg:"video/mpeg",oga:"audio/ogg",ogv:"video/ogg",ogx:"application/ogg",opus:"audio/opus",otf:"font/otf",pdf:"application/pdf",png:"image/png",rtf:"application/rtf",svg:"image/svg+xml",tif:"image/tiff",tiff:"image/tiff",ts:"video/mp2t",ttf:"font/ttf",txt:"text/plain",wasm:"application/wasm",webm:"video/webm",weba:"audio/webm",webmanifest:"application/manifest+json",webp:"image/webp",woff:"font/woff",woff2:"font/woff2",xhtml:"application/xhtml+xml",xml:"application/xml",zip:"application/zip","3gp":"video/3gpp","3g2":"video/3gpp2",gltf:"model/gltf+json",glb:"model/gltf-binary"},jr=Sr,Rr=(...e)=>{let t=e.filter(a=>a!=="").join("/");t=t.replace(new RegExp("(?<=\\/)\\/+","g"),"");const r=t.split("/"),s=[];for(const a of r)a===".."&&s.length>0&&s.at(-1)!==".."?s.pop():a!=="."&&s.push(a);return s.join("/")||"."},Pt={br:".br",zstd:".zst",gzip:".gz"},Ar=Object.keys(Pt),kr="index.html",Pr=e=>{const t=e.root??"./",r=e.path,s=e.join??Rr;return async(a,n)=>{var u,f,h,x;if(a.finalized)return n();let o;if(e.path)o=e.path;else try{if(o=decodeURIComponent(a.req.path),/(?:^|[\/\\])\.\.(?:$|[\/\\])/.test(o))throw new Error}catch{return await((u=e.onNotFound)==null?void 0:u.call(e,a.req.path,a)),n()}let i=s(t,!r&&e.rewriteRequestPath?e.rewriteRequestPath(o):o);e.isDir&&await e.isDir(i)&&(i=s(i,kr));const l=e.getContent;let d=await l(i,a);if(d instanceof Response)return a.newResponse(d.body,d);if(d){const P=e.mimes&&Qe(i,e.mimes)||Qe(i);if(a.header("Content-Type",P||"application/octet-stream"),e.precompressed&&(!P||Er.test(P))){const v=new Set((f=a.req.header("Accept-Encoding"))==null?void 0:f.split(",").map(y=>y.trim()));for(const y of Ar){if(!v.has(y))continue;const A=await l(i+Pt[y],a);if(A){d=A,a.header("Content-Encoding",y),a.header("Vary","Accept-Encoding",{append:!0});break}}}return await((h=e.onFound)==null?void 0:h.call(e,i,a)),a.body(d)}await((x=e.onNotFound)==null?void 0:x.call(e,i,a)),await n()}},Ir=async(e,t)=>{let r;t&&t.manifest?typeof t.manifest=="string"?r=JSON.parse(t.manifest):r=t.manifest:typeof __STATIC_CONTENT_MANIFEST=="string"?r=JSON.parse(__STATIC_CONTENT_MANIFEST):r=__STATIC_CONTENT_MANIFEST;let s;t&&t.namespace?s=t.namespace:s=__STATIC_CONTENT;const a=r[e]||e;if(!a)return null;const n=await s.get(a,{type:"stream"});return n||null},Tr=e=>async function(r,s){return Pr({...e,getContent:async n=>Ir(n,{manifest:e.manifest,namespace:e.namespace?e.namespace:r.env?r.env.__STATIC_CONTENT:void 0})})(r,s)},Cr=e=>Tr(e),$r=/^[\w!#$%&'*.^`|~+-]+$/,Mr=/^[ !#-:<-[\]-~]*$/,Hr=(e,t)=>{if(e.indexOf(t)===-1)return{};const r=e.trim().split(";"),s={};for(let a of r){a=a.trim();const n=a.indexOf("=");if(n===-1)continue;const o=a.substring(0,n).trim();if(t!==o||!$r.test(o))continue;let i=a.substring(n+1).trim();if(i.startsWith('"')&&i.endsWith('"')&&(i=i.slice(1,-1)),Mr.test(i)){s[o]=i.indexOf("%")!==-1?Ce(i,Fe):i;break}}return s},Dr=(e,t,r={})=>{let s=`${e}=${t}`;if(e.startsWith("__Secure-")&&!r.secure)throw new Error("__Secure- Cookie must have Secure attributes");if(e.startsWith("__Host-")){if(!r.secure)throw new Error("__Host- Cookie must have Secure attributes");if(r.path!=="/")throw new Error('__Host- Cookie must have Path attributes with "/"');if(r.domain)throw new Error("__Host- Cookie must not have Domain attributes")}if(r&&typeof r.maxAge=="number"&&r.maxAge>=0){if(r.maxAge>3456e4)throw new Error("Cookies Max-Age SHOULD NOT be greater than 400 days (34560000 seconds) in duration.");s+=`; Max-Age=${r.maxAge|0}`}if(r.domain&&r.prefix!=="host"&&(s+=`; Domain=${r.domain}`),r.path&&(s+=`; Path=${r.path}`),r.expires){if(r.expires.getTime()-Date.now()>3456e7)throw new Error("Cookies Expires SHOULD NOT be greater than 400 days (34560000 seconds) in the future.");s+=`; Expires=${r.expires.toUTCString()}`}if(r.httpOnly&&(s+="; HttpOnly"),r.secure&&(s+="; Secure"),r.sameSite&&(s+=`; SameSite=${r.sameSite.charAt(0).toUpperCase()+r.sameSite.slice(1)}`),r.priority&&(s+=`; Priority=${r.priority.charAt(0).toUpperCase()+r.priority.slice(1)}`),r.partitioned){if(!r.secure)throw new Error("Partitioned Cookie must have Secure attributes");s+="; Partitioned"}return s},_e=(e,t,r)=>(t=encodeURIComponent(t),Dr(e,t,r)),It=(e,t,r)=>{const s=e.req.raw.headers.get("Cookie");{if(!s)return;let a=t;return Hr(s,a)[a]}},Or=(e,t,r)=>{let s;return(r==null?void 0:r.prefix)==="secure"?s=_e("__Secure-"+e,t,{path:"/",...r,secure:!0}):(r==null?void 0:r.prefix)==="host"?s=_e("__Host-"+e,t,{...r,path:"/",secure:!0,domain:void 0}):s=_e(e,t,{path:"/",...r}),s},Ue=(e,t,r,s)=>{const a=Or(t,r,s);e.header("Set-Cookie",a,{append:!0})},Tt=e=>$t(e.replace(/_|-/g,t=>({_:"/","-":"+"})[t]??t)),Ct=e=>_r(e).replace(/\/|\+/g,t=>({"/":"_","+":"-"})[t]??t),_r=e=>{let t="";const r=new Uint8Array(e);for(let s=0,a=r.length;s<a;s++)t+=String.fromCharCode(r[s]);return btoa(t)},$t=e=>{const t=atob(e),r=new Uint8Array(new ArrayBuffer(t.length)),s=t.length/2;for(let a=0,n=t.length-1;a<=s;a++,n--)r[a]=t.charCodeAt(a),r[n]=t.charCodeAt(n);return r},Mt=(e=>(e.HS256="HS256",e.HS384="HS384",e.HS512="HS512",e.RS256="RS256",e.RS384="RS384",e.RS512="RS512",e.PS256="PS256",e.PS384="PS384",e.PS512="PS512",e.ES256="ES256",e.ES384="ES384",e.ES512="ES512",e.EdDSA="EdDSA",e))(Mt||{}),Nr={deno:"Deno",bun:"Bun",workerd:"Cloudflare-Workers",node:"Node.js"},Br=()=>{var r,s;const e=globalThis;if(typeof navigator<"u"&&typeof navigator.userAgent=="string"){for(const[a,n]of Object.entries(Nr))if(Lr(n))return a}return typeof(e==null?void 0:e.EdgeRuntime)=="string"?"edge-light":(e==null?void 0:e.fastly)!==void 0?"fastly":((s=(r=e==null?void 0:e.process)==null?void 0:r.release)==null?void 0:s.name)==="node"?"node":"other"},Lr=e=>navigator.userAgent.startsWith(e),zr=class extends Error{constructor(e){super(`${e} is not an implemented algorithm`),this.name="JwtAlgorithmNotImplemented"}},Ht=class extends Error{constructor(e){super(`invalid JWT token: ${e}`),this.name="JwtTokenInvalid"}},Jr=class extends Error{constructor(e){super(`token (${e}) is being used before it's valid`),this.name="JwtTokenNotBefore"}},Fr=class extends Error{constructor(e){super(`token (${e}) expired`),this.name="JwtTokenExpired"}},Ur=class extends Error{constructor(e,t){super(`Invalid "iat" claim, must be a valid number lower than "${e}" (iat: "${t}")`),this.name="JwtTokenIssuedAt"}},Ne=class extends Error{constructor(e,t){super(`expected issuer "${e}", got ${t?`"${t}"`:"none"} `),this.name="JwtTokenIssuer"}},qr=class extends Error{constructor(e){super(`jwt header is invalid: ${JSON.stringify(e)}`),this.name="JwtHeaderInvalid"}},Wr=class extends Error{constructor(e){super(`token(${e}) signature mismatched`),this.name="JwtTokenSignatureMismatched"}},Kr=class extends Error{constructor(e){super(`required "aud" in jwt payload: ${JSON.stringify(e)}`),this.name="JwtPayloadRequiresAud"}},Vr=class extends Error{constructor(e,t){super(`expected audience "${Array.isArray(e)?e.join(", "):e}", got "${t}"`),this.name="JwtTokenAudience"}},he=(e=>(e.Encrypt="encrypt",e.Decrypt="decrypt",e.Sign="sign",e.Verify="verify",e.DeriveKey="deriveKey",e.DeriveBits="deriveBits",e.WrapKey="wrapKey",e.UnwrapKey="unwrapKey",e))(he||{}),Ee=new TextEncoder,Gr=new TextDecoder;async function Yr(e,t,r){const s=Dt(t),a=await Qr(e,s);return await crypto.subtle.sign(s,a,r)}async function Xr(e,t,r,s){const a=Dt(t),n=await Zr(e,a);return await crypto.subtle.verify(a,n,r,s)}function Je(e){return $t(e.replace(/-+(BEGIN|END).*/g,"").replace(/\s/g,""))}async function Qr(e,t){if(!crypto.subtle||!crypto.subtle.importKey)throw new Error("`crypto.subtle.importKey` is undefined. JWT auth middleware requires it.");if(Ot(e)){if(e.type!=="private"&&e.type!=="secret")throw new Error(`unexpected key type: CryptoKey.type is ${e.type}, expected private or secret`);return e}const r=[he.Sign];return typeof e=="object"?await crypto.subtle.importKey("jwk",e,t,!1,r):e.includes("PRIVATE")?await crypto.subtle.importKey("pkcs8",Je(e),t,!1,r):await crypto.subtle.importKey("raw",Ee.encode(e),t,!1,r)}async function Zr(e,t){if(!crypto.subtle||!crypto.subtle.importKey)throw new Error("`crypto.subtle.importKey` is undefined. JWT auth middleware requires it.");if(Ot(e)){if(e.type==="public"||e.type==="secret")return e;e=await Ze(e)}if(typeof e=="string"&&e.includes("PRIVATE")){const s=await crypto.subtle.importKey("pkcs8",Je(e),t,!0,[he.Sign]);e=await Ze(s)}const r=[he.Verify];return typeof e=="object"?await crypto.subtle.importKey("jwk",e,t,!1,r):e.includes("PUBLIC")?await crypto.subtle.importKey("spki",Je(e),t,!1,r):await crypto.subtle.importKey("raw",Ee.encode(e),t,!1,r)}async function Ze(e){if(e.type!=="private")throw new Error(`unexpected key type: ${e.type}`);if(!e.extractable)throw new Error("unexpected private key is unextractable");const t=await crypto.subtle.exportKey("jwk",e),{kty:r}=t,{alg:s,e:a,n}=t,{crv:o,x:i,y:l}=t;return{kty:r,alg:s,e:a,n,crv:o,x:i,y:l,key_ops:[he.Verify]}}function Dt(e){switch(e){case"HS256":return{name:"HMAC",hash:{name:"SHA-256"}};case"HS384":return{name:"HMAC",hash:{name:"SHA-384"}};case"HS512":return{name:"HMAC",hash:{name:"SHA-512"}};case"RS256":return{name:"RSASSA-PKCS1-v1_5",hash:{name:"SHA-256"}};case"RS384":return{name:"RSASSA-PKCS1-v1_5",hash:{name:"SHA-384"}};case"RS512":return{name:"RSASSA-PKCS1-v1_5",hash:{name:"SHA-512"}};case"PS256":return{name:"RSA-PSS",hash:{name:"SHA-256"},saltLength:32};case"PS384":return{name:"RSA-PSS",hash:{name:"SHA-384"},saltLength:48};case"PS512":return{name:"RSA-PSS",hash:{name:"SHA-512"},saltLength:64};case"ES256":return{name:"ECDSA",hash:{name:"SHA-256"},namedCurve:"P-256"};case"ES384":return{name:"ECDSA",hash:{name:"SHA-384"},namedCurve:"P-384"};case"ES512":return{name:"ECDSA",hash:{name:"SHA-512"},namedCurve:"P-521"};case"EdDSA":return{name:"Ed25519",namedCurve:"Ed25519"};default:throw new zr(e)}}function Ot(e){return Br()==="node"&&crypto.webcrypto?e instanceof crypto.webcrypto.CryptoKey:e instanceof CryptoKey}var Be=e=>Ct(Ee.encode(JSON.stringify(e)).buffer).replace(/=/g,""),es=e=>Ct(e).replace(/=/g,""),et=e=>JSON.parse(Gr.decode(Tt(e)));function ts(e){if(typeof e=="object"&&e!==null){const t=e;return"alg"in t&&Object.values(Mt).includes(t.alg)&&(!("typ"in t)||t.typ==="JWT")}return!1}var rs=async(e,t,r="HS256")=>{const s=Be(e);let a;typeof t=="object"&&"alg"in t?(r=t.alg,a=Be({alg:r,typ:"JWT",kid:t.kid})):a=Be({alg:r,typ:"JWT"});const n=`${a}.${s}`,o=await Yr(t,r,Ee.encode(n)),i=es(o);return`${n}.${i}`},ss=async(e,t,r)=>{const s=typeof r=="string"?{alg:r}:r||{},a={alg:s.alg??"HS256",iss:s.iss,nbf:s.nbf??!0,exp:s.exp??!0,iat:s.iat??!0,aud:s.aud},n=e.split(".");if(n.length!==3)throw new Ht(e);const{header:o,payload:i}=as(e);if(!ts(o))throw new qr(o);const l=Date.now()/1e3|0;if(a.nbf&&i.nbf&&i.nbf>l)throw new Jr(e);if(a.exp&&i.exp&&i.exp<=l)throw new Fr(e);if(a.iat&&i.iat&&l<i.iat)throw new Ur(l,i.iat);if(a.iss){if(!i.iss)throw new Ne(a.iss,null);if(typeof a.iss=="string"&&i.iss!==a.iss)throw new Ne(a.iss,i.iss);if(a.iss instanceof RegExp&&!a.iss.test(i.iss))throw new Ne(a.iss,i.iss)}if(a.aud&&!i.aud)throw new Kr(i);if(i.aud){const h=(Array.isArray(i.aud)?i.aud:[i.aud]).some(x=>{if(a.aud instanceof RegExp&&a.aud.test(x))return!0;if(typeof a.aud=="string"){if(x===a.aud)return!0}else if(Array.isArray(a.aud)&&a.aud.includes(x))return!0;return!1});if(a.aud&&!h)throw new Vr(a.aud,i.aud)}const d=e.substring(0,e.lastIndexOf("."));if(!await Xr(t,a.alg,Tt(n[2]),Ee.encode(d)))throw new Wr(e);return i},as=e=>{try{const[t,r]=e.split("."),s=et(t),a=et(r);return{header:s,payload:a}}catch{throw new Ht(e)}},_t={sign:rs,verify:ss},ns=_t.verify,os=_t.sign;const S=new kt;async function Nt(e){const r=new TextEncoder().encode(e),s=await crypto.subtle.digest("SHA-256",r);return Array.from(new Uint8Array(s)).map(a=>a.toString(16).padStart(2,"0")).join("")}async function Bt(e,t,r){const s=await os({userId:t,exp:Math.floor(Date.now()/1e3)+604800},r),a=new Date(Date.now()+10080*60*1e3).toISOString();return await e.prepare("INSERT INTO sessions (user_id, token, expires_at) VALUES (?, ?, ?)").bind(t,s,a).run(),s}async function qe(e){const t=It(e,"auth_token");if(!t)return null;try{const r=await ns(t,e.env.JWT_SECRET);return await e.env.DB.prepare("SELECT id, email, name, plan, credits FROM users WHERE id = ?").bind(r.userId).first()}catch{return null}}async function Se(e,t){const r=await qe(e);if(!r)return e.json({error:"로그인이 필요합니다."},401);e.set("user",r),await t()}S.use("/api/*",wr());S.use("/static/*",Cr({root:"./public"}));S.get("/api/health",e=>e.json({status:"ok",message:"AI Fortune Telling Platform"}));S.post("/api/auth/register",async e=>{try{const{email:t,password:r,name:s,phone:a,birthDate:n,gender:o}=await e.req.json();if(!t||!r||!s)return e.json({error:"필수 정보를 입력해주세요."},400);if(await e.env.DB.prepare("SELECT id FROM users WHERE email = ?").bind(t).first())return e.json({error:"이미 가입된 이메일입니다."},400);const l=await Nt(r),u=(await e.env.DB.prepare("INSERT INTO users (email, password_hash, name, phone, birth_date, gender) VALUES (?, ?, ?, ?, ?, ?)").bind(t,l,s,a||null,n||null,o||null).run()).meta.last_row_id,f=await Bt(e.env.DB,u,e.env.JWT_SECRET);return Ue(e,"auth_token",f,{httpOnly:!0,secure:!0,sameSite:"Lax",maxAge:10080*60}),e.json({success:!0,user:{id:u,email:t,name:s,plan:"free",credits:3}})}catch(t){return console.error("Register error:",t),e.json({error:"회원가입 중 오류가 발생했습니다."},500)}});S.post("/api/auth/login",async e=>{try{const{email:t,password:r}=await e.req.json();if(!t||!r)return e.json({error:"이메일과 비밀번호를 입력해주세요."},400);const s=await Nt(r),a=await e.env.DB.prepare("SELECT id, email, name, plan, credits FROM users WHERE email = ? AND password_hash = ?").bind(t,s).first();if(!a)return e.json({error:"이메일 또는 비밀번호가 올바르지 않습니다."},401);const n=await Bt(e.env.DB,a.id,e.env.JWT_SECRET);return Ue(e,"auth_token",n,{httpOnly:!0,secure:!0,sameSite:"Lax",maxAge:10080*60}),e.json({success:!0,user:a})}catch(t){return console.error("Login error:",t),e.json({error:"로그인 중 오류가 발생했습니다."},500)}});S.post("/api/auth/logout",async e=>{const t=It(e,"auth_token");return t&&await e.env.DB.prepare("DELETE FROM sessions WHERE token = ?").bind(t).run(),Ue(e,"auth_token","",{maxAge:0}),e.json({success:!0})});S.get("/api/auth/me",async e=>{const t=await qe(e);return t?e.json({user:t}):e.json({error:"로그인이 필요합니다."},401)});S.get("/api/user/profile",Se,async e=>{const t=e.get("user");return e.json({user:t})});S.put("/api/user/profile",Se,async e=>{const t=e.get("user"),{name:r,phone:s,birthDate:a}=await e.req.json();return await e.env.DB.prepare("UPDATE users SET name = ?, phone = ?, birth_date = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?").bind(r,s,a,t.id).run(),e.json({success:!0})});S.get("/api/user/readings",Se,async e=>{const t=e.get("user"),{results:r}=await e.env.DB.prepare("SELECT * FROM readings WHERE user_id = ? ORDER BY created_at DESC LIMIT 50").bind(t.id).all();return e.json({readings:r})});S.post("/api/user/credits/purchase",Se,async e=>{const t=e.get("user"),{credits:r,amount:s}=await e.req.json();return await e.env.DB.prepare("INSERT INTO payments (user_id, amount, credits, payment_method, status) VALUES (?, ?, ?, ?, ?)").bind(t.id,s,r,"card","completed").run(),await e.env.DB.prepare("UPDATE users SET credits = credits + ? WHERE id = ?").bind(r,t.id).run(),e.json({success:!0,credits:r})});S.post("/api/user/plan/upgrade",Se,async e=>{const t=e.get("user"),{plan:r,amount:s}=await e.req.json();return await e.env.DB.prepare("INSERT INTO payments (user_id, amount, plan, payment_method, status) VALUES (?, ?, ?, ?, ?)").bind(t.id,s,r,"card","completed").run(),await e.env.DB.prepare("UPDATE users SET plan = ? WHERE id = ?").bind(r,t.id).run(),e.json({success:!0,plan:r})});S.post("/api/face-reading",async e=>{try{const t=await qe(e);if(!t)return e.json({error:"로그인이 필요한 서비스입니다. 회원가입하고 무료 3회 체험하세요!"},401);if(t.credits<1&&t.plan==="free")return e.json({error:"크레딧이 부족합니다. 요금제를 업그레이드하거나 크레딧을 구매해주세요."},403);const s=(await e.req.formData()).get("image");if(!s)return e.json({error:"이미지를 업로드해주세요."},400);if(s instanceof File){if(!["image/jpeg","image/jpg","image/png","image/webp"].includes(s.type))return e.json({error:"JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다."},400);const i=10*1024*1024;if(s.size>i)return e.json({error:"이미지 크기는 10MB 이하여야 합니다."},400);console.log(`Face image uploaded: ${s.name}, ${s.size} bytes, ${s.type}`)}const n={faceShape:"계란형",features:{eyes:"큰 눈으로 총명함과 예술적 재능이 있습니다",nose:"곧은 콧대로 강한 의지와 리더십을 보여줍니다",mouth:"미소가 아름답고 대인관계가 원만합니다",forehead:"넓은 이마로 지혜롭고 통찰력이 뛰어납니다"},fortune:{wealth:"재물운이 매우 좋으며, 특히 30대 후반에 큰 기회가 찾아옵니다",love:"진실한 사랑을 만날 운명입니다. 운명적 만남이 가까이 있습니다",career:"현재 직장에서 승진운이 보이며, 리더십을 발휘할 기회가 옵니다",health:"전반적으로 건강하나, 스트레스 관리에 신경 쓰세요"},celebrities:[{name:"아이유",similarity:92,fortune:"부귀영화"},{name:"손예진",similarity:88,fortune:"좋은 인연"},{name:"전지현",similarity:85,fortune:"성공운"}],luckyColor:"보라색",luckyNumber:7,luckyDay:"수요일"};return e.json(n)}catch{return e.json({error:"분석 중 오류가 발생했습니다."},500)}});S.post("/api/palm-reading",async e=>{try{const r=(await e.req.formData()).get("image");if(!r)return e.json({error:"손바닥 이미지를 업로드해주세요."},400);if(r instanceof File){if(!["image/jpeg","image/jpg","image/png","image/webp"].includes(r.type))return e.json({error:"JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다."},400);const n=10*1024*1024;if(r.size>n)return e.json({error:"이미지 크기는 10MB 이하여야 합니다."},400);console.log(`Palm image uploaded: ${r.name}, ${r.size} bytes, ${r.type}`)}const s={handShape:"물형",lines:{lifeLine:"생명선이 길고 뚜렷하여 건강하고 장수할 운명입니다",heartLine:"감정선이 안정적이며 행복한 연애와 결혼생활을 약속합니다",headLine:"두뇌선이 직선적이고 강하여 논리적 사고가 뛰어납니다",fateLine:"운명선이 뚜렷하여 자신만의 길을 개척해 나갈 것입니다"},fortune:{wealth:"재물선이 좋아 노후 걱정 없이 살 수 있습니다",love:"애정선이 깊어 평생 좋은 인연과 함께 할 것입니다",career:"사업선이 강하여 자수성가할 가능성이 높습니다",health:"건강선이 양호하나 40대 이후 건강관리 필요"},specialMarks:["재물운을 상징하는 별 표시가 있습니다","지혜를 나타내는 삼각형 문양이 보입니다"],luckyAge:[28,35,42,56]};return e.json(s)}catch{return e.json({error:"분석 중 오류가 발생했습니다."},500)}});S.post("/api/saju",async e=>{try{const{year:t,month:r,day:s,hour:a,gender:n}=await e.req.json();if(!t||!r||!s)return e.json({error:"생년월일을 입력해주세요."},400);const o={fourPillars:{year:"壬寅 (임인)",month:"癸未 (계미)",day:"甲申 (갑신)",hour:a?"丙辰 (병진)":"시간 미입력"},elements:{primary:"木 (나무)",secondary:"水 (물)",lucky:"火 (불)",unlucky:"金 (쇠)"},personality:{strengths:["창의적","리더십","추진력","친화력"],weaknesses:["급한 성격","독단적","계획성 부족"],suitable:"예술, 교육, 경영, 방송"},fortune:{this_year:"올해는 새로운 기회가 많이 찾아오는 해입니다. 특히 상반기에 중요한 결정을 내리게 될 것입니다.",next_5_years:"향후 5년간 운세가 상승하며, 특히 재물운과 명예운이 좋습니다.",life_turning_points:[30,38,45,52,60]},compatibility:{best_match:["토끼띠","말띠","개띠"],good_match:["양띠","돼지띠"],caution_match:["원숭이띠","뱀띠"]},advice:"현재의 노력이 빛을 발할 시기입니다. 자신감을 가지고 새로운 도전을 해보세요."};return e.json(o)}catch{return e.json({error:"분석 중 오류가 발생했습니다."},500)}});S.post("/api/tarot",async e=>{try{const{question:t,spread:r}=await e.req.json(),s=[{name:"마법사",position:"past",meaning:"과거에 자신의 능력을 발휘할 기회가 있었습니다"},{name:"여황제",position:"present",meaning:"현재 풍요로움과 창조성이 넘치는 시기입니다"},{name:"황제",position:"future",meaning:"미래에 권위와 안정을 얻게 될 것입니다"}];return e.json({question:t||"오늘의 운세",spread:r||"three-card",cards:s,overall:"전반적으로 긍정적인 흐름이 보입니다. 과거의 경험을 바탕으로 현재를 즐기고 미래를 준비하세요."})}catch{return e.json({error:"타로 리딩 중 오류가 발생했습니다."},500)}});S.get("/api/zodiac/:sign",e=>{const t=e.req.param("sign"),r={overall:"오늘은 전반적으로 좋은 날입니다. 새로운 기회를 잡을 준비를 하세요.",love:"사랑운이 상승하고 있습니다. 좋은 만남이 예상됩니다.",career:"직장에서 인정받을 일이 생길 것입니다.",wealth:"작은 재물운이 있으나 충동구매는 자제하세요.",health:"건강 상태가 양호합니다. 규칙적인 운동을 추천합니다.",luckyColor:"파란색",luckyNumber:3,compatibility:["물병자리","쌍둥이자리"]};return e.json({sign:t,today:r})});S.get("/",e=>e.html(`
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>운세의 신 - AI 기반 종합 운세 플랫폼</title>
        <script src="https://cdn.tailwindcss.com"><\/script>
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
        <style>
            * {
                font-family: 'Noto Sans KR', sans-serif;
            }
            .gradient-bg {
                background: linear-gradient(135deg, #ff6b35 0%, #f7931e 50%, #ff9a56 100%);
            }
            .glass-effect {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            }
            .service-card {
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                cursor: pointer;
                border: 2px solid transparent;
            }
            .service-card:hover {
                transform: translateY(-8px) scale(1.02);
                box-shadow: 0 25px 50px rgba(255, 107, 53, 0.3);
                border-color: rgba(255, 107, 53, 0.3);
            }
            .fade-in {
                animation: fadeIn 0.6s ease-in;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            }
            .modal.active {
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .modal-content {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                max-width: 600px;
                width: 90%;
                max-height: 90vh;
                overflow-y: auto;
                animation: slideUp 0.3s ease-out;
                position: relative;
                user-select: text;
                -webkit-user-select: text;
                -moz-user-select: text;
                -ms-user-select: text;
            }
            .modal-content::-webkit-scrollbar {
                width: 8px;
            }
            .modal-content::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }
            .modal-content::-webkit-scrollbar-thumb {
                background: #ff6b35;
                border-radius: 10px;
            }
            .modal-content::-webkit-scrollbar-thumb:hover {
                background: #f7931e;
            }
            @keyframes slideUp {
                from { transform: translateY(50px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }
            .result-section {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                border-radius: 15px;
                padding: 1.5rem;
                margin: 1rem 0;
            }
            .celeb-card {
                background: white;
                border-radius: 10px;
                padding: 1rem;
                margin: 0.5rem 0;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
        </style>
    </head>
    <body class="gradient-bg min-h-screen">
        <!-- Header -->
        <header class="py-6 px-4">
            <div class="max-w-6xl mx-auto flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-moon text-white text-3xl"></i>
                    <h1 class="text-white text-2xl font-bold">운세의 신</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <div id="userMenu" class="hidden text-white">
                        <span class="bg-white/20 px-4 py-2 rounded-lg">
                            <i class="fas fa-coins"></i> <span id="creditDisplay">3</span>회
                        </span>
                        <button onclick="openModal('profile')" class="ml-2 bg-white/20 px-4 py-2 rounded-lg hover:bg-white/30">
                            <i class="fas fa-user"></i> <span id="userName">마이페이지</span>
                        </button>
                    </div>
                    <div id="authButtons" class="flex space-x-2">
                        <button onclick="openModal('login')" class="text-white bg-white/20 px-4 py-2 rounded-lg hover:bg-white/30">
                            로그인
                        </button>
                        <button onclick="openModal('register')" class="text-white bg-orange-500 px-4 py-2 rounded-lg hover:bg-orange-600">
                            회원가입
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="max-w-4xl mx-auto px-4 pb-12">
            <!-- Hero Section -->
            <div class="glass-effect rounded-3xl p-10 mb-6 fade-in text-center">
                <h2 class="text-5xl font-bold text-gray-800 mb-6" style="font-family: 'Noto Sans KR', sans-serif;">
                    당신의 운명을 만나보세요
                </h2>
                <p class="text-gray-700 text-lg mb-6">
                    전통 철학과 AI 기술이 만난 프리미엄 운세 서비스
                </p>
                <div class="bg-orange-50 border-2 border-orange-300 rounded-2xl p-5 mb-6 inline-block shadow-sm">
                    <p class="text-orange-800 font-bold text-xl mb-2">
                        🎁 지금 회원가입하고 <span class="text-3xl text-orange-600">무료 3회</span> 체험하세요!
                    </p>
                    <p class="text-orange-700 text-sm">
                        프리미엄 회원은 무제한 이용 가능 ✨
                    </p>
                </div>
                <div class="flex justify-center gap-8 text-base text-orange-700">
                    <span class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-orange-500"></i> AI 관상 분석
                    </span>
                    <span class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-orange-500"></i> 셀럽 닮은꼴
                    </span>
                    <span class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-orange-500"></i> 정통 사주
                    </span>
                </div>
            </div>

            <!-- Service Cards -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <!-- Face Reading -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('face')">
                    <div class="text-7xl mb-6">📸</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">AI 관상</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        얼굴 사진으로 운세 분석<br/>+ 셀럽 닮은꼴 찾기
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            📷 사진 촬영
                        </span>
                    </div>
                </div>

                <!-- Palm Reading -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('palm')" style="animation-delay: 0.1s">
                    <div class="text-7xl mb-6">🤚</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">AI 수상</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        손바닥 사진으로<br/>손금 운세 해석
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            🖐️ 손바닥 촬영
                        </span>
                    </div>
                </div>

                <!-- Saju -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('saju')" style="animation-delay: 0.2s">
                    <div class="text-7xl mb-6">🔮</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">사주팔자</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        생년월일시로<br/>정통 사주 풀이
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            📅 생년월일 입력
                        </span>
                    </div>
                </div>

                <!-- Tarot -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('tarot')" style="animation-delay: 0.3s">
                    <div class="text-7xl mb-6">🃏</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">타로 & 별자리</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        디지털 타로카드와<br/>12궁도 운세
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            🌟 카드 선택
                        </span>
                    </div>
                </div>
            </div>

            <!-- Features -->
            <div class="glass-effect rounded-3xl p-10 fade-in">
                <h3 class="text-3xl font-bold text-gray-800 mb-8 text-center">왜 운세의 신인가요?</h3>
                <div class="grid md:grid-cols-3 gap-8">
                    <div class="text-center">
                        <div class="text-6xl mb-4">🎯</div>
                        <h4 class="font-bold text-gray-800 text-lg mb-3">정확한 AI 분석</h4>
                        <p class="text-gray-600 text-sm leading-relaxed">최신 AI 기술로 정밀한 관상·수상 분석</p>
                    </div>
                    <div class="text-center">
                        <div class="text-6xl mb-4">⭐</div>
                        <h4 class="font-bold text-gray-800 text-lg mb-3">빠른 결과물</h4>
                        <p class="text-gray-600 text-sm leading-relaxed">유명 연예인과 얼굴 비교 분석</p>
                    </div>
                    <div class="text-center">
                        <div class="text-6xl mb-4">🔒</div>
                        <h4 class="font-bold text-gray-800 text-lg mb-3">안전한 서비스</h4>
                        <p class="text-gray-600 text-sm leading-relaxed">개인정보 보호와 보안 최우선</p>
                    </div>
                </div>
            </div>
        </main>

        <!-- Face Reading Modal -->
        <div id="faceModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">📸 AI 관상 분석</h3>
                    <button onclick="closeModal('face')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="faceContent">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">얼굴 사진 업로드</label>
                        <input type="file" id="faceImage" accept="image/jpeg,image/jpg,image/png,image/webp" class="w-full p-3 border-2 border-orange-200 rounded-lg" onchange="previewImage('face')">
                        <p class="text-xs text-gray-500 mt-2">* JPG, PNG, WEBP 형식, 최대 10MB</p>
                        <div id="facePreview" class="mt-4 hidden">
                            <img id="facePreviewImg" class="max-w-full rounded-lg" />
                        </div>
                    </div>
                    <button onclick="analyzeFace()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-magic mr-2"></i>AI 관상 분석 시작
                    </button>
                </div>
                <div id="faceResult" class="hidden"></div>
            </div>
        </div>

        <!-- Palm Reading Modal -->
        <div id="palmModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🤚 AI 수상 분석</h3>
                    <button onclick="closeModal('palm')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="palmContent">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">손바닥 사진 업로드</label>
                        <input type="file" id="palmImage" accept="image/jpeg,image/jpg,image/png,image/webp" class="w-full p-3 border-2 border-orange-200 rounded-lg" onchange="previewImage('palm')">
                        <p class="text-xs text-gray-500 mt-2">* JPG, PNG, WEBP 형식, 최대 10MB</p>
                        <div id="palmPreview" class="mt-4 hidden">
                            <img id="palmPreviewImg" class="max-w-full rounded-lg" />
                        </div>
                    </div>
                    <button onclick="analyzePalm()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-hand-sparkles mr-2"></i>AI 수상 분석 시작
                    </button>
                </div>
                <div id="palmResult" class="hidden"></div>
            </div>
        </div>

        <!-- Saju Modal -->
        <div id="sajuModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🔮 사주팔자 분석</h3>
                    <button onclick="closeModal('saju')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="sajuContent">
                    <div class="space-y-4 mb-6">
                        <div>
                            <label class="block text-gray-700 font-semibold mb-2">생년월일</label>
                            <input type="date" id="sajuBirthdate" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                        </div>
                        <div>
                            <label class="block text-gray-700 font-semibold mb-2">출생 시간 (선택)</label>
                            <input type="time" id="sajuBirthtime" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                        </div>
                        <div>
                            <label class="block text-gray-700 font-semibold mb-2">성별</label>
                            <select id="sajuGender" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                                <option value="female">여성</option>
                                <option value="male">남성</option>
                            </select>
                        </div>
                    </div>
                    <button onclick="analyzeSaju()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-yin-yang mr-2"></i>사주팔자 분석 시작
                    </button>
                </div>
                <div id="sajuResult" class="hidden"></div>
            </div>
        </div>

        <!-- Tarot Modal -->
        <div id="tarotModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🃏 타로 & 별자리</h3>
                    <button onclick="closeModal('tarot')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="tarotContent">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">질문하기 (선택)</label>
                        <textarea id="tarotQuestion" rows="3" class="w-full p-3 border-2 border-orange-200 rounded-lg" placeholder="오늘의 운세가 궁금해요..."></textarea>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">별자리 선택</label>
                        <select id="zodiacSign" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                            <option value="aries">양자리</option>
                            <option value="taurus">황소자리</option>
                            <option value="gemini">쌍둥이자리</option>
                            <option value="cancer">게자리</option>
                            <option value="leo">사자자리</option>
                            <option value="virgo">처녀자리</option>
                            <option value="libra">천칭자리</option>
                            <option value="scorpio">전갈자리</option>
                            <option value="sagittarius">사수자리</option>
                            <option value="capricorn">염소자리</option>
                            <option value="aquarius">물병자리</option>
                            <option value="pisces">물고기자리</option>
                        </select>
                    </div>
                    <button onclick="analyzeTarot()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-magic mr-2"></i>타로 & 별자리 운세 보기
                    </button>
                </div>
                <div id="tarotResult" class="hidden"></div>
            </div>
        </div>

        <!-- Login Modal -->
        <div id="loginModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🔐 로그인</h3>
                    <button onclick="closeModal('login')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="space-y-4">
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">이메일</label>
                        <input type="email" id="loginEmail" class="w-full p-3 border-2 border-orange-200 rounded-lg" placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">비밀번호</label>
                        <input type="password" id="loginPassword" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                    </div>
                    <button onclick="login()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700">
                        로그인
                    </button>
                    <p class="text-center text-sm text-gray-600">
                        계정이 없으신가요? <button onclick="closeModal('login'); openModal('register');" class="text-orange-600 font-semibold">회원가입</button>
                    </p>
                </div>
            </div>
        </div>

        <!-- Register Modal -->
        <div id="registerModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🎁 회원가입</h3>
                    <button onclick="closeModal('register')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="bg-orange-100 p-4 rounded-lg mb-4">
                    <p class="text-orange-800 font-semibold text-center">
                        🎉 회원가입하고 무료 3회 체험하세요!
                    </p>
                </div>
                <div class="space-y-4">
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">이름</label>
                        <input type="text" id="regName" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">이메일</label>
                        <input type="email" id="regEmail" class="w-full p-3 border-2 border-orange-200 rounded-lg" placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">비밀번호</label>
                        <input type="password" id="regPassword" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                    </div>
                    <button onclick="register()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700">
                        회원가입
                    </button>
                    <p class="text-center text-sm text-gray-600">
                        이미 계정이 있으신가요? <button onclick="closeModal('register'); openModal('login');" class="text-orange-600 font-semibold">로그인</button>
                    </p>
                </div>
            </div>
        </div>

        <!-- Profile/Pricing Modal -->
        <div id="profileModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">👤 마이페이지</h3>
                    <button onclick="closeModal('profile')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="space-y-4">
                    <div class="bg-orange-100 p-4 rounded-lg">
                        <p class="font-bold text-orange-800">현재 요금제: <span id="currentPlan">무료 체험</span></p>
                        <p class="text-orange-700">남은 크레딧: <span id="currentCredits">3</span>회</p>
                    </div>
                    <button onclick="openModal('pricing')" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700">
                        💎 요금제 업그레이드
                    </button>
                    <button onclick="logout()" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300">
                        로그아웃
                    </button>
                </div>
            </div>
        </div>

        <!-- Pricing Modal -->
        <div id="pricingModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">💎 요금제 안내</h3>
                    <button onclick="closeModal('pricing')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="space-y-4">
                    <div class="border-2 border-gray-300 rounded-lg p-4">
                        <h4 class="font-bold text-lg mb-2">🆓 무료 체험</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">0원</p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 3회 무료 체험</li>
                            <li>✓ 모든 운세 서비스 이용</li>
                        </ul>
                    </div>
                    <div class="border-2 border-orange-300 bg-orange-50 rounded-lg p-4">
                        <h4 class="font-bold text-lg mb-2">⭐ 스탠다드</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">9,900원<span class="text-sm">/월</span></p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 월 30회 이용</li>
                            <li>✓ 모든 운세 서비스</li>
                            <li>✓ 히스토리 저장</li>
                        </ul>
                        <button class="w-full mt-3 bg-orange-600 text-white py-2 rounded-lg hover:bg-orange-700">
                            구독하기
                        </button>
                    </div>
                    <div class="border-2 border-orange-500 bg-orange-100 rounded-lg p-4">
                        <div class="bg-orange-600 text-white px-3 py-1 rounded-full inline-block text-xs mb-2">추천</div>
                        <h4 class="font-bold text-lg mb-2">💎 프리미엄</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">19,900원<span class="text-sm">/월</span></p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 무제한 이용</li>
                            <li>✓ 모든 운세 서비스</li>
                            <li>✓ 히스토리 무제한 저장</li>
                            <li>✓ 전문가 상담 1회</li>
                        </ul>
                        <button class="w-full mt-3 bg-orange-600 text-white py-2 rounded-lg hover:bg-orange-700">
                            구독하기
                        </button>
                    </div>
                    <div class="border-2 border-orange-600 bg-orange-50 rounded-lg p-4">
                        <h4 class="font-bold text-lg mb-2">👑 VIP</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">39,900원<span class="text-sm">/월</span></p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 무제한 이용</li>
                            <li>✓ 우선 분석 처리</li>
                            <li>✓ 전문가 상담 3회</li>
                            <li>✓ 맞춤형 운세 리포트</li>
                        </ul>
                        <button class="w-full mt-3 bg-orange-600 text-white py-2 rounded-lg hover:bg-orange-700">
                            구독하기
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/axios@1.6.0/dist/axios.min.js"><\/script>
        <script>
            function openModal(type) {
                document.getElementById(type + 'Modal').classList.add('active');
            }

            function closeModal(type) {
                document.getElementById(type + 'Modal').classList.remove('active');
                // Reset form
                document.getElementById(type + 'Result').classList.add('hidden');
                document.getElementById(type + 'Content').classList.remove('hidden');
            }

            function previewImage(type) {
                const input = document.getElementById(type + 'Image');
                const preview = document.getElementById(type + 'Preview');
                const previewImg = document.getElementById(type + 'PreviewImg');

                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        previewImg.src = e.target.result;
                        preview.classList.remove('hidden');
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }

            async function analyzeFace() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const imageInput = document.getElementById('faceImage');
                if (!imageInput.files || !imageInput.files[0]) {
                    alert('얼굴 사진을 업로드해주세요.');
                    return;
                }

                // Validate file type
                const file = imageInput.files[0];
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                if (!allowedTypes.includes(file.type)) {
                    alert('JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다.');
                    return;
                }

                // Validate file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('이미지 크기는 10MB 이하여야 합니다.');
                    return;
                }

                const formData = new FormData();
                formData.append('image', file);

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const response = await axios.post('/api/face-reading', formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data'
                        }
                    });
                    const data = response.data;

                    let celebsHtml = data.celebrities.map(celeb => \`
                        <div class="celeb-card">
                            <div>
                                <div class="font-bold text-orange-800">\${celeb.name}</div>
                                <div class="text-sm text-gray-600">\${celeb.fortune}</div>
                            </div>
                            <div class="text-orange-600 font-bold">\${celeb.similarity}%</div>
                        </div>
                    \`).join('');

                    document.getElementById('faceResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">✨ 셀럽 닮은꼴 분석</h4>
                            \${celebsHtml}
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">👤 관상 분석</h4>
                            <p class="mb-3"><strong>얼굴형:</strong> \${data.faceShape}</p>
                            <div class="space-y-2">
                                <p><strong>👁️ 눈:</strong> \${data.features.eyes}</p>
                                <p><strong>👃 코:</strong> \${data.features.nose}</p>
                                <p><strong>👄 입:</strong> \${data.features.mouth}</p>
                                <p><strong>🧠 이마:</strong> \${data.features.forehead}</p>
                            </div>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🔮 운세</h4>
                            <p class="mb-2"><strong>💰 재물운:</strong> \${data.fortune.wealth}</p>
                            <p class="mb-2"><strong>💕 애정운:</strong> \${data.fortune.love}</p>
                            <p class="mb-2"><strong>💼 사업운:</strong> \${data.fortune.career}</p>
                            <p class="mb-2"><strong>🏥 건강운:</strong> \${data.fortune.health}</p>
                            <hr class="my-4">
                            <p><strong>🎨 행운의 색:</strong> \${data.luckyColor}</p>
                            <p><strong>🔢 행운의 숫자:</strong> \${data.luckyNumber}</p>
                            <p><strong>📅 행운의 요일:</strong> \${data.luckyDay}</p>
                        </div>

                        <button onclick="closeModal('face')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    // Use credit on success
                    useCredit();
                    
                    document.getElementById('faceContent').classList.add('hidden');
                    document.getElementById('faceResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Face reading error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }

            async function analyzePalm() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const imageInput = document.getElementById('palmImage');
                if (!imageInput.files || !imageInput.files[0]) {
                    alert('손바닥 사진을 업로드해주세요.');
                    return;
                }

                // Validate file type
                const file = imageInput.files[0];
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                if (!allowedTypes.includes(file.type)) {
                    alert('JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다.');
                    return;
                }

                // Validate file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('이미지 크기는 10MB 이하여야 합니다.');
                    return;
                }

                const formData = new FormData();
                formData.append('image', file);

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const response = await axios.post('/api/palm-reading', formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data'
                        }
                    });
                    const data = response.data;

                    let specialMarksHtml = data.specialMarks.map(mark => \`
                        <li class="flex items-start">
                            <i class="fas fa-star text-orange-600 mr-2 mt-1"></i>
                            <span>\${mark}</span>
                        </li>
                    \`).join('');

                    document.getElementById('palmResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🤚 수상 분석</h4>
                            <p class="mb-3"><strong>손 모양:</strong> \${data.handShape}</p>
                            <div class="space-y-2">
                                <p><strong>🌱 생명선:</strong> \${data.lines.lifeLine}</p>
                                <p><strong>💗 감정선:</strong> \${data.lines.heartLine}</p>
                                <p><strong>🧠 두뇌선:</strong> \${data.lines.headLine}</p>
                                <p><strong>✨ 운명선:</strong> \${data.lines.fateLine}</p>
                            </div>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🔮 운세</h4>
                            <p class="mb-2"><strong>💰 재물운:</strong> \${data.fortune.wealth}</p>
                            <p class="mb-2"><strong>💕 애정운:</strong> \${data.fortune.love}</p>
                            <p class="mb-2"><strong>💼 사업운:</strong> \${data.fortune.career}</p>
                            <p class="mb-2"><strong>🏥 건강운:</strong> \${data.fortune.health}</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">⭐ 특별한 표시</h4>
                            <ul class="space-y-2">
                                \${specialMarksHtml}
                            </ul>
                            <hr class="my-4">
                            <p><strong>🎂 행운의 나이:</strong> \${data.luckyAge.join('세, ')}세</p>
                        </div>

                        <button onclick="closeModal('palm')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    document.getElementById('palmContent').classList.add('hidden');
                    document.getElementById('palmResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Palm reading error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }

            async function analyzeSaju() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const birthdate = document.getElementById('sajuBirthdate').value;
                const birthtime = document.getElementById('sajuBirthtime').value;
                const gender = document.getElementById('sajuGender').value;

                if (!birthdate) {
                    alert('생년월일을 입력해주세요.');
                    return;
                }

                const [year, month, day] = birthdate.split('-');

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const response = await axios.post('/api/saju', {
                        year: parseInt(year),
                        month: parseInt(month),
                        day: parseInt(day),
                        hour: birthtime || null,
                        gender: gender
                    });
                    const data = response.data;

                    let strengthsHtml = data.personality.strengths.map(s => \`<span class="bg-orange-100 text-orange-800 px-3 py-1 rounded-full text-sm">\${s}</span>\`).join(' ');
                    let bestMatchHtml = data.compatibility.best_match.map(s => \`<span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">\${s}</span>\`).join(' ');

                    document.getElementById('sajuResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🔮 사주팔자</h4>
                            <div class="grid grid-cols-2 gap-3">
                                <p><strong>년주:</strong> \${data.fourPillars.year}</p>
                                <p><strong>월주:</strong> \${data.fourPillars.month}</p>
                                <p><strong>일주:</strong> \${data.fourPillars.day}</p>
                                <p><strong>시주:</strong> \${data.fourPillars.hour}</p>
                            </div>
                            <hr class="my-4">
                            <p><strong>🌳 주요 오행:</strong> \${data.elements.primary}</p>
                            <p><strong>💧 보조 오행:</strong> \${data.elements.secondary}</p>
                            <p><strong>✨ 행운의 오행:</strong> \${data.elements.lucky}</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">👤 성격 분석</h4>
                            <p class="mb-3"><strong>장점:</strong></p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                \${strengthsHtml}
                            </div>
                            <p><strong>💼 적합한 직업:</strong> \${data.personality.suitable}</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">📅 운세</h4>
                            <p class="mb-3"><strong>올해 운세:</strong><br/>\${data.fortune.this_year}</p>
                            <p class="mb-3"><strong>향후 5년:</strong><br/>\${data.fortune.next_5_years}</p>
                            <p><strong>🎯 인생 전환기:</strong> \${data.fortune.life_turning_points.join('세, ')}세</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">💑 궁합</h4>
                            <p class="mb-2"><strong>최고의 궁합:</strong></p>
                            <div class="flex flex-wrap gap-2 mb-3">
                                \${bestMatchHtml}
                            </div>
                            <hr class="my-3">
                            <p class="text-orange-700 font-semibold">💡 조언: \${data.advice}</p>
                        </div>

                        <button onclick="closeModal('saju')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    document.getElementById('sajuContent').classList.add('hidden');
                    document.getElementById('sajuResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Saju analysis error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }

            async function analyzeTarot() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const question = document.getElementById('tarotQuestion').value;
                const zodiacSign = document.getElementById('zodiacSign').value;

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const [tarotResponse, zodiacResponse] = await Promise.all([
                        axios.post('/api/tarot', { question: question, spread: 'three-card' }),
                        axios.get(\`/api/zodiac/\${zodiacSign}\`)
                    ]);

                    const tarotData = tarotResponse.data;
                    const zodiacData = zodiacResponse.data;

                    let cardsHtml = tarotData.cards.map(card => \`
                        <div class="bg-white p-4 rounded-lg mb-3">
                            <div class="font-bold text-orange-800 mb-2">🃏 \${card.name} (\${card.position})</div>
                            <p class="text-gray-700 text-sm">\${card.meaning}</p>
                        </div>
                    \`).join('');

                    document.getElementById('tarotResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🃏 타로 리딩</h4>
                            <p class="mb-4"><strong>질문:</strong> \${tarotData.question}</p>
                            \${cardsHtml}
                            <div class="bg-orange-100 p-4 rounded-lg mt-4">
                                <p class="text-orange-800 font-semibold">💫 종합 해석</p>
                                <p class="text-gray-700 mt-2">\${tarotData.overall}</p>
                            </div>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">⭐ \${zodiacData.sign} 별자리 운세</h4>
                            <p class="mb-2"><strong>📝 종합운:</strong> \${zodiacData.today.overall}</p>
                            <p class="mb-2"><strong>💕 애정운:</strong> \${zodiacData.today.love}</p>
                            <p class="mb-2"><strong>💼 직장운:</strong> \${zodiacData.today.career}</p>
                            <p class="mb-2"><strong>💰 재물운:</strong> \${zodiacData.today.wealth}</p>
                            <p class="mb-2"><strong>🏥 건강운:</strong> \${zodiacData.today.health}</p>
                            <hr class="my-4">
                            <p><strong>🎨 행운의 색:</strong> \${zodiacData.today.luckyColor}</p>
                            <p><strong>🔢 행운의 숫자:</strong> \${zodiacData.today.luckyNumber}</p>
                        </div>

                        <button onclick="closeModal('tarot')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    document.getElementById('tarotContent').classList.add('hidden');
                    document.getElementById('tarotResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Tarot analysis error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }
            // Platform functions
            function initPlatform() {
                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user) {
                    document.getElementById('authButtons').classList.add('hidden');
                    document.getElementById('userMenu').classList.remove('hidden');
                    document.getElementById('userName').textContent = user.name;
                    document.getElementById('creditDisplay').textContent = user.credits;
                } else {
                    // Give 1 free trial for non-members
                    if (!localStorage.getItem('trialUsed')) {
                        localStorage.setItem('trialCredits', '1');
                    }
                }
            }

            function register() {
                const email = document.getElementById('regEmail').value;
                const password = document.getElementById('regPassword').value;
                const name = document.getElementById('regName').value;

                if (!email || !password || !name) {
                    alert('모든 항목을 입력해주세요.');
                    return;
                }

                const user = {
                    email,
                    name,
                    plan: 'free',
                    credits: 3,
                    joined: new Date().toISOString()
                };

                localStorage.setItem('fortuneUser', JSON.stringify(user));
                closeModal('register');
                initPlatform();
                alert('회원가입이 완료되었습니다! 무료 3회 체험을 시작하세요 🎉');
            }

            function login() {
                const email = document.getElementById('loginEmail').value;
                const password = document.getElementById('loginPassword').value;

                if (!email || !password) {
                    alert('이메일과 비밀번호를 입력해주세요.');
                    return;
                }

                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user && user.email === email) {
                    closeModal('login');
                    initPlatform();
                    alert('로그인되었습니다!');
                } else {
                    alert('등록되지 않은 사용자입니다. 회원가입해주세요.');
                }
            }

            function logout() {
                if (confirm('로그아웃하시겠습니까?')) {
                    localStorage.removeItem('fortuneUser');
                    location.reload();
                }
            }

            function checkCredits() {
                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user) {
                    if (user.plan !== 'free') {
                        return true; // Unlimited for premium users
                    }
                    if (user.credits > 0) {
                        return true;
                    }
                    alert('크레딧이 부족합니다. 요금제를 업그레이드하거나 크레딧을 구매해주세요.');
                    openModal('pricing');
                    return false;
                } else {
                    const trialCredits = parseInt(localStorage.getItem('trialCredits') || '0');
                    if (trialCredits > 0) {
                        return true;
                    }
                    alert('체험 기회를 모두 사용했습니다. 회원가입하고 무료 3회를 더 받으세요!');
                    openModal('register');
                    return false;
                }
            }

            function useCredit() {
                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user && user.plan === 'free') {
                    user.credits--;
                    localStorage.setItem('fortuneUser', JSON.stringify(user));
                    document.getElementById('creditDisplay').textContent = user.credits;
                } else if (!user) {
                    const trialCredits = parseInt(localStorage.getItem('trialCredits') || '0');
                    localStorage.setItem('trialCredits', (trialCredits - 1).toString());
                }
            }

            // Initialize platform on load
            window.addEventListener('DOMContentLoaded', initPlatform);
        <\/script>
    </body>
    </html>
  `));const tt=new kt,is=Object.assign({"/src/index.tsx":S});let Lt=!1;for(const[,e]of Object.entries(is))e&&(tt.route("/",e),tt.notFound(e.notFoundHandler),Lt=!0);if(!Lt)throw new Error("Can't import modules from ['/src/index.tsx','/app/server.ts']");export{tt as default};
